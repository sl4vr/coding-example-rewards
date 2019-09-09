# frozen_string_literal: true

require_relative 'base'

module Rewards
  module Actions
    # Recommendation of one customer by another one
    class Recommend < Base
      def initialize(**args)
        super(**args)

        @customer_name = args[:customer_name]
        @recommended_name = args[:recommended_name]
      end

      def perform
        raise NotImplementedError, 'TBD'
      end
    end
  end
end
