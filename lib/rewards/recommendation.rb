# frozen_string_literal: true

module Rewards
  # Recommendation model
  class Recommendation
    RecommendationError = Class.new(StandardError)
    NoCustomerError = Class.new(RecommendationError)
    NoRecommendedNameError = Class.new(RecommendationError)

    attr_reader :created_at, :customer, :recommended_name,
      :recommended_customer, :active

    def initialize(customer:, recommended_name:, created_at: nil)
      if customer.blank?
        raise NoCustomerError, 'No customer given'
      end
      if recommended_name.blank?
        raise NoRecommendedNameError, 'No recommended_name given'
      end

      @customer = customer
      @recommended_name = recommended_name
      @created_at = created_at || Time.now
      @active = false
    end
  end
end
