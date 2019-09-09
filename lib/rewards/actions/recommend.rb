# frozen_string_literal: true

require_relative 'base'

module Rewards
  module Actions
    # Recommendation of one customer by another one
    class Recommend < Base
      RecommendError = Class.new(StandardError)
      CustomerNotFoundError = Class.new(RecommendError)
      RecommendationCreationError = Class.new(RecommendError)

      def initialize(**args)
        super(**args)

        @customer_name = args[:customer_name]
        @recommended_name = args[:recommended_name]
      end

      def perform(customers:, recommendations:)
        customer = customers.find(@customer_name)

        unless customer
          raise CustomerNotFoundError, "Customer #{@customer_name} not found"
        end

        recommendations.create(
          customer: customer,
          recommended_name: @recommended_name,
          created_at: @created_at
        )
      rescue Recommendation::RecommendationError => error
        raise RecommendationCreationError, error.message
      end
    end
  end
end
