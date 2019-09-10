# frozen_string_literal: true

module Rewards
  # Calculates reward for customers in actions log
  class Calculator
    def initialize(input:, parser:, customers:, recommendations:)
      @input = input
      @parser = parser
      @customers = customers
      @recommendations = recommendations
    end

    def calculate
      actions = @parser.new(@input).parse

      actions.sort_by(&:created_at).each do |action|
        action.perform(customers: @customers, recommendations: @recommendations)
      end

      @customers.all.each_with_object({}) do |customer, hash|
        hash[customer.name] = customer.score if customer.score > 0
      end
    end
  end
end
