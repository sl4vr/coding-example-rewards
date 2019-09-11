# frozen_string_literal: true

require 'spec_helper'

describe Rewards::Rewarder do
  let(:customer_a) { Rewards::Customer.new('A') }
  let(:customer_b) { Rewards::Customer.new('B') }
  let(:customer_c) { Rewards::Customer.new('C') }

  let(:recommendation_repo) do
    repository = Rewards::RecommendationRepository.new
    repository.instance_variable_set('@recommendations', recommendations)
    repository
  end

  let(:recommendation_a_b) do
    recommendation = Rewards::Recommendation.new(
      created_at: DateTime.parse('2018-06-01 09:41'),
      customer: customer_a,
      recommended_name: 'B'
    )
    recommendation.active = true
    recommendation.recommended_customer = customer_b
    recommendation
  end
  let(:recommendation_b_c) do
    recommendation = Rewards::Recommendation.new(
      created_at: DateTime.parse('2018-06-02 09:41'),
      customer: customer_b,
      recommended_name: 'C'
    )
    recommendation.active = true
    recommendation.recommended_customer = customer_c
    recommendation
  end
  let(:recommendation_a_c) do
    recommendation = Rewards::Recommendation.new(
      created_at: DateTime.parse('2018-06-03 09:41'),
      customer: customer_a,
      recommended_name: 'C'
    )
    recommendation.recommended_customer = customer_c
    recommendation
  end

  let(:recommendations) do
    [recommendation_a_b, recommendation_b_c, recommendation_a_c]
  end

  subject(:rewarder) do
    Rewards::Rewarder.new(customer_c, recommendations: recommendation_repo)
  end

  describe '#reward' do
    it 'rewards chain of recommenders' do
      expect { rewarder.reward }.to change(customer_b, :score).by(1.0)
      expect { rewarder.reward }.to change(customer_a, :score).by(0.5)
    end

    context 'when chain is broken' do
      before { recommendation_a_b.active = false }

      it 'rewards until recommendations exist' do
        expect { rewarder.reward }.to change(customer_b, :score).by(1.0)
        expect { rewarder.reward }.not_to change(customer_a, :score)
      end
    end
  end
end
