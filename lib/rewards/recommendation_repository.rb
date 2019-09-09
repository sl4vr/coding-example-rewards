# frozen_string_literal: true

module Rewards
  # Recommendation store and access
  class RecommendationRepository
    RecommendationRepositoryError = Class.new(StandardError)
    RecommendationNotFoundError = Class.new(RecommendationRepositoryError)

    def initialize
      @recommendations = []
    end

    def find_by_recommended_name(recommended_name)
      recommendation = @recommendations.find do |recommendation|
        recommendation.recommended_name == recommended_name
      end

      unless recommendation
        raise RecommendationNotFoundError,
              "No Recommendation for #{recommended_name}"
      end

      recommendation
    end

    def create(**args)
      recommendation = Recommendation.new(**args)
      @recommendations << recommendation
      recommendation
    end

    def all
      @recommendations
    end
  end
end
