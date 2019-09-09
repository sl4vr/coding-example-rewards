# frozen_string_literal: true

module Rewards
  # Recommendation store and access
  class RecommendationRepository
    def initialize
      @recommendations = []
    end

    def select_by_recommended_name(recommended_name)
      all.select do |recommendation|
        recommendation.recommended_name == recommended_name
      end
    end

    def create(**args)
      recommendation = Recommendation.new(**args)
      @recommendations << recommendation
      recommendation
    end

    def all
      @recommendations.sort_by(&:created_at)
    end
  end
end
