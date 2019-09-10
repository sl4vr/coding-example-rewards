# frozen_string_literal: true

require 'spec_helper'

describe Rewards::RecommendationRepository do
  subject(:recommendation_repo) do
    repository = Rewards::RecommendationRepository.new
    repository.instance_variable_set('@recommendations', recommendations)
    repository
  end

  let(:recommendation_a_b) do
    Rewards::Recommendation.new(
      created_at: DateTime.parse('2018-06-19 09:41'),
      customer: Rewards::Customer.new('A'),
      recommended_name: 'B'
    )
  end
  let(:recommendation_d_b) do
    Rewards::Recommendation.new(
      created_at: DateTime.parse('2018-06-15 09:41'),
      customer: Rewards::Customer.new('D'),
      recommended_name: 'B'
    )
  end
  let(:recommendation_x_y) do
    Rewards::Recommendation.new(
      created_at: DateTime.parse('2018-06-17 09:41'),
      customer: Rewards::Customer.new('X'),
      recommended_name: 'Y'
    )
  end

  let(:recommendations) do
    [recommendation_a_b, recommendation_d_b, recommendation_x_y]
  end

  describe '.new' do
    subject(:recommendation_repo) { Rewards::RecommendationRepository.new }

    it 'creates empty repository' do
      expect(
        recommendation_repo.instance_variable_get('@recommendations')
      ).to be_empty
    end
  end

  describe '#select_by_recommended_name' do
    let(:recommended_name) { 'B' }

    it 'returns recommendations with given recommended_name' do
      expect(
        recommendation_repo.select_by_recommended_name(recommended_name)
      ).to match_array([recommendation_a_b, recommendation_d_b])
    end

    it 'returns recommendations sorted from latest to newest by created_at' do
      recommendation = recommendation_repo
        .select_by_recommended_name(recommended_name)

      expect(recommendation.first).to eq(recommendation_d_b)
    end

    context 'when recommendation does NOT exist' do
      let(:recommended_name) { 'D' }

      it 'returns empty array' do
        expect(
          recommendation_repo.select_by_recommended_name(recommended_name)
        ).to match_array([])
      end
    end
  end

  describe '#select_active_by_recommended' do
    let(:customer_b) { Rewards::Customer.new('B') }
    let(:customer_y) { Rewards::Customer.new('Y') }

    let(:recommendation_a_b) do
      recommendation = super()
      recommendation.recommended_customer = customer_b
      recommendation.active = true
      recommendation
    end
    let(:recommendation_d_b) do
      recommendation = super()
      recommendation.recommended_customer = customer_b
      recommendation.active = false
      recommendation
    end
    let(:recommendation_x_y) do
      recommendation = super()
      recommendation.recommended_customer = customer_y
      recommendation.active = true
      recommendation
    end

    subject(:select_active_by_recommended) do
      recommendation_repo.select_active_by_recommended(customer_b)
    end

    it { is_expected.to be_kind_of(Array) }

    it 'returns array of active recommendations for customer' do
      is_expected.to match_array([recommendation_a_b])
    end
  end

  describe '#create' do
    let(:customer) { Rewards::Customer.new('A') }
    let(:recommended_name) { 'D' }

    subject(:create) do
      recommendation_repo.create(
        customer: customer,
        recommended_name: recommended_name
      )
    end

    it 'creates recommendation and stores it in repository' do
      create

      expect(
        recommendation_repo.instance_variable_get('@recommendations').count
      ).to eq(4)
    end

    context 'when no customer given' do
      let(:customer) { nil }

      it 'raises RecommendationError' do
        expect {
          create
        }.to raise_error(Rewards::Recommendation::RecommendationError)
      end
    end

    context 'when no recommended_name given' do
      let(:recommended_name) { nil }

      it 'raises RecommendationError' do
        expect {
          create
        }.to raise_error(Rewards::Recommendation::RecommendationError)
      end
    end
  end

  describe '#all' do
    it 'returns recommendations array' do
      expect(recommendation_repo.all).to match_array(recommendations)
    end

    it 'returns recommendations sorted from newest to latest by create_at' do
      expect(recommendation_repo.all.first).to eq(recommendation_d_b)
    end
  end
end
