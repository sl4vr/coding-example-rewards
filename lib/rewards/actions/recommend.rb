# frozen_string_literal: true

module Rewards
  module Actions
    # Recommendation of one customer by another one
    class Recommend
      RecommendError = Class.new(StandardError)
      CustomerNotFoundError = Class.new(RecommendError)
      RecommendationCreationError = Class.new(RecommendError)

      def initialize(params:, customers:, recommendations:)
        @created_at = params[:created_at] || Time.now
        @customer_name = params[:customer_name]
        @recommended_name = params[:recommended_name]

        @customers = customers
        @recommendations = recommendations
      end

      def perform
        customer = @customers.find_or_create(@customer_name)

        unless customer
          raise CustomerNotFoundError, "Customer #{@customer_name} not found"
        end

        @recommendations.create(
          customer: customer,
          recommended_name: @recommended_name,
          created_at: @created_at
        )
      rescue Recommendation::RecommendationError,
             Customer::NoNameError => error
        raise RecommendationCreationError, error.message
      end
    end
  end
end
