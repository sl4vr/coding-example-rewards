# frozen_string_literal: true

module Rewards
  module Actions
    # Abstract class, representing base Action interface
    class Base
      attr_reader :created_at

      def initialize(**args)
        @created_at = args[:created_at] || Time.now
      end

      def perform(customers:, recommendations:)
        raise NotImplementedError,
              'perform method called for abstract Actions::Base'
      end
    end
  end
end
