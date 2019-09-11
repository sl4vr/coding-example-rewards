# frozen_string_literal: true

module Rewards
  # Calculates reward for customers in actions log
  class Calculator
    def initialize(parser:, customers:, recommendations:)
      @parser = parser
      @customers = customers
      @recommendations = recommendations
    end

    def calculate
      actions = @parser.parse

      actions.sort_by(&:created_at).each do |action|
        perform_action(action)
      end

      @customers.all.each_with_object({}) do |customer, hash|
        hash[customer.name] = customer.score if customer.score > 0
      end
    end

    private

    def perform_action(action)
      action.perform(customers: @customers, recommendations: @recommendations)
    rescue  Actions::Accept::AcceptError,
            Actions::Recommend::RecommendError
    end
  end
end
