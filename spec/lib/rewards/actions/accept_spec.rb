# frozen_string_literal: true

require 'spec_helper'

describe Rewards::Actions::Accept do
  let(:customer_repo) do
    repository = Rewards::CustomerRepository.new
    repository.instance_variable_set('@customers', customers)
    repository
  end

  let(:customer_a) { Rewards::Customer.new('A') }
  let(:customer_b) { Rewards::Customer.new('B') }
  let(:customer_c) { Rewards::Customer.new('C') }

  let(:customers) { [customer_a, customer_b, customer_c] }

  let(:recommendation_repo) do
    repository = Rewards::RecommendationRepository.new
    repository.instance_variable_set('@recommendations', recommendations)
    repository
  end

  let(:recommendation_a_d) do
    Rewards::Recommendation.new(
      created_at: DateTime.parse('2018-06-19 09:41'),
      customer: customer_a,
      recommended_name: 'D'
    )
  end
  let(:recommendation_b_d) do
    Rewards::Recommendation.new(
      created_at: DateTime.parse('2018-06-15 09:41'),
      customer: customer_b,
      recommended_name: 'D'
    )
  end

  let(:recommendations) { [recommendation_a_d, recommendation_b_d] }

  let(:recommended_name) { 'D' }
  subject(:action) do
    Rewards::Actions::Accept.new(
      params: {
        customer_name: recommended_name
      },
      customers: customer_repo,
      recommendations: recommendation_repo
    )
  end

  describe '#perform' do
    subject(:action_perform) { action.perform }

    it 'creates customer with customer name' do
      action_perform

      created_customer = customer_repo.find(recommended_name)

      expect(created_customer).not_to be_nil
    end

    it 'sets customer as recommended_customer to all recommendations found' do
      action_perform

      recommendations = recommendation_repo
        .select_by_recommended_name(recommended_name)

      recommendations.each do |recommendation|
        expect(recommendation.recommended_customer).not_to be_nil
        expect(recommendation.recommended_customer.name).to eq(recommended_name)
      end
    end

    it 'activate latest recommendations found' do
      action_perform

      expect(recommendation_b_d.active).to be(true)
    end

    it 'runs rewarder for new customer' do
      customer_d = customer_repo.create('D')
      expect(customer_repo).to receive(:create).and_return(customer_d)

      expect(Rewards::Rewarder).to receive(:new)
        .with(customer_d, recommendations: recommendation_repo)
        .and_return(
          Rewards::Rewarder.new(
            customer_d,
            recommendations: recommendation_repo
            )
          )
      expect_any_instance_of(Rewards::Rewarder).to receive(:reward)

      action_perform
    end

    context 'when no customer name given' do
      let(:recommended_name) { nil }

      it 'raises CustomerCreationError' do
        expect {
          action_perform
        }.to raise_error(Rewards::Actions::Accept::CustomerCreationError)
      end
    end

    context 'when there are no recommendations' do
      let(:recommendations) { [] }

      it 'raises NoRecommendationsError' do
        expect {
          action_perform
        }.to raise_error(Rewards::Actions::Accept::NoRecommendationsError)
      end
    end
  end
end
