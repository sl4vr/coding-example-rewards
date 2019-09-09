# frozen_string_literal: true

require_relative 'base'

module Rewards
  module Actions
    # Acceptance of invitation by new customer
    class Accept < Base
      AcceptError = Class.new(StandardError)
      NoRecommendationsError = Class.new(AcceptError)
      CustomerCreationError = Class.new(AcceptError)

      def initialize(**args)
        super(**args)

        @customer_name = args[:customer_name]
      end

      def perform(customers:, recommendations:)
        customer = customers.create(@customer_name)
        recommendations = recommendations
          .select_by_recommended_name(@customer_name)

        if recommendations.empty?
          raise NoRecommendationsError,
                "No recommendations for #{@customer_name}"
        end

        recommendations.each do |recommendation|
          recommendation.recommended_customer = customer
        end

        recommendations.first.active = true
      rescue Customer::CustomerError => error
        raise CustomerCreationError, error.message
      end
    end
  end
end
