# frozen_string_literal: true

module Rewards
  # Customer model
  class Customer
    CustomerError = Class.new(StandardError)
    NoNameError = Class.new(CustomerError)
    NonNumericScoreError = Class.new(CustomerError)

    attr_reader :name, :score

    def initialize(name)
      raise NoNameError, 'No name given' if name.blank?

      @name = name
      @score = 0.0
    end

    def add_score(score)
      unless score.is_a?(Numeric)
        raise NonNumericScoreError,
              "Score must be Numeric, but instead is #{score.class}"
      end

      @score += score
    end
  end
end
