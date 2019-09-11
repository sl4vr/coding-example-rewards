# frozen_string_literal: true

module Rewards
  # Rewards customers in recommendation chain
  class Rewarder
    def initialize(recommendations)
      @recommendations = recommendations
    end

    def reward_for(customer)
      reward_customer(customer)
    end

    private

    def reward_customer(customer, score = 1.0)
      recommendations = @recommendations.select_active_by_recommended(customer)

      recommendations.each do |recommendation|
        customer_to_reward = recommendation.customer
        customer_to_reward.add_score(score)
        reduced_score = score.fdiv(2)
        reward_customer(customer_to_reward, reduced_score)
      end
    end
  end
end
