# frozen_string_literal: true

module Rewards
  module Actions
    # Acceptance of invitation by new customer
    class Accept
      AcceptError = Class.new(StandardError)
      NoRecommendationsError = Class.new(AcceptError)
      CustomerCreationError = Class.new(AcceptError)

      def initialize(params:, customers:, recommendations:)
        @created_at = params[:created_at] || Time.now
        @customer_name = params[:customer_name]

        @customers = customers
        @recommendations = recommendations
      end

      def perform
        customer = @customers.create(@customer_name)
        recommendations = @recommendations
          .select_by_recommended_name(@customer_name)

        if recommendations.empty?
          raise NoRecommendationsError,
                "No recommendations for #{@customer_name}"
        end

        recommendations.each do |recommendation|
          recommendation.recommended_customer = customer
        end

        recommendations.first.active = true

        Rewarder.new(customer, recommendations: @recommendations).reward
      rescue Customer::CustomerError => error
        raise CustomerCreationError, error.message
      end
    end
  end
end
