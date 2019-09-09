# frozen_string_literal: true

require_relative 'base'

module Rewards
  module Actions
    # Acceptance of invitation by new customer
    class Accept < Base
      def initialize(**args)
        super(**args)

        @customer_name = args[:customer_name]
      end

      def perform
        raise NotImplementedError, 'TBD'
      end
    end
  end
end
