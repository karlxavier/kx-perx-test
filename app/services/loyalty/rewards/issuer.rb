module Loyalty
  module Rewards
    class Issuer
      class RewardsIssuanceError < StandardError; end

      attr_accessor :user

      def initialize(user:)
        @user = user
      end

      def call
        calculation_issuing_rules.each do |rule|
          Ruler.new(rule:, user:).acquire_points!
        end
      end

      private

      def calculation_issuing_rules
        @calculation_issuing_rules ||= RewardsIssuingRule.active
      end
    end
  end
end
