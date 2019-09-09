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
      customer: Rewards::Customer.new('A'),
      recommended_name: 'B'
    )
  end

  let(:recommendations) { [recommendation_a_b] }

  describe '.new' do
    subject(:recommendation_repo) { Rewards::RecommendationRepository.new }

    it 'creates empty repository' do
      expect(
        recommendation_repo.instance_variable_get('@recommendations')
      ).to be_empty
    end
  end

  describe '#find_by_recommended_name' do
    let(:recommended_name) { 'B' }

    it 'returns recommendation with given recommended_name' do
      recommendation = recommendation_repo
        .find_by_recommended_name(recommended_name)

      expect(recommendation).to be(recommendation_a_b)
    end

    context 'when recommendation does NOT exist' do
      let(:recommended_name) { 'D' }

      it 'raises RecommendationNotFoundError' do
        expect {
          recommendation_repo.find_by_recommended_name(recommended_name)
        }.to raise_error(
          Rewards::RecommendationRepository::RecommendationNotFoundError
        )
      end
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
      ).to eq(2)
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
      expect(recommendation_repo.all).to match(recommendations)
    end
  end
end
