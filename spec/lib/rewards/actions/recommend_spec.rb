# frozen_string_literal: true

require 'spec_helper'

describe Rewards::Actions::Recommend do
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

  let(:customer_name) { 'A' }
  let(:recommended_name) { 'E' }
  let(:created_at) { DateTime.parse('2018-06-22 09:41') }
  subject(:action) do
    Rewards::Actions::Recommend.new(
      customer_name: customer_name,
      recommended_name: recommended_name,
      created_at: created_at
    )
  end
  
  describe '#perform' do
    subject(:action_perform) do
      action.perform(
        customers: customer_repo,
        recommendations: recommendation_repo
      )
    end

    it 'creates recommendation with data provided' do
      action_perform

      recommendation = recommendation_repo.all.last

      expect(recommendation.customer).to eq(customer_a)
      expect(recommendation.recommended_name).to eq(recommended_name)
      expect(recommendation.created_at).to eq(created_at)
    end

    context 'when no such customer' do
      let(:customer_name) { 'X' }

      it 'raises CustomerNotFoundError' do
        expect{
          action_perform
        }.to raise_error(Rewards::Actions::Recommend::CustomerNotFoundError)
      end
    end

    context 'when no customer name given' do
      let(:customer_name) { nil }

      it 'raises CustomerNotFoundError' do
        expect{
          action_perform
        }.to raise_error(
          Rewards::Actions::Recommend::CustomerNotFoundError
        )
      end
    end

    context 'when no recommended_name name given' do
      let(:recommended_name) { nil }

      it 'raises RecommendationCreationError' do
        expect{
          action_perform
        }.to raise_error(
          Rewards::Actions::Recommend::RecommendationCreationError
        )
      end
    end

    context 'when no created_at name given' do
      let(:created_at) { nil }

      it 'creates recommendation with created_at == Time.now' do
        action_perform
  
        recommendation = recommendation_repo.all.last
  
        expect(recommendation.customer).to eq(customer_a)
        expect(recommendation.recommended_name).to eq(recommended_name)
        expect(recommendation.created_at).not_to be_nil
      end
    end
  end
end
