# frozen_string_literal: true

module Rewards
  module Params
    # Recommend action data structure
    class Recommend
      attr_reader :customer_name, :recommended_name, :created_at

      def initialize(customer_name:, recommended_name:, created_at:)
        @customer_name = customer_name
        @recommended_name = recommended_name
        @created_at = created_at
      end

      def to_h
        {
          customer_name: @customer_name,
          recommended_name: recommended_name,
          created_at: @created_at
        }
      end
    end
  end
end
