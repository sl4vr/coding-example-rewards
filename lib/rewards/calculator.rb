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
      actions_params = @parser.parse

      actions_params.sort_by(&:created_at).each do |params|
        perform_action(params)
      end

      @customers.all.each_with_object({}) do |customer, hash|
        hash[customer.name] = customer.score if customer.score > 0
      end
    end

    private

    def perform_action(params)
      action =
        case params
        when Params::Accept
          Actions::Accept.new(
            params: params.to_h,
            customers: @customers,
            recommendations: @recommendations
          )
        when Params::Recommend
          Actions::Recommend.new(
            params: params.to_h,
            customers: @customers,
            recommendations: @recommendations
          )
        end

      action.perform
    rescue  Actions::Accept::AcceptError,
            Actions::Recommend::RecommendError
    end
  end
end
