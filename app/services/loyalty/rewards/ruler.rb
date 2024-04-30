module Loyalty
  module Rewards
    class Ruler
      class RewardsIssuanceError < StandardError; end

      attr_accessor :rule, :user

      def initialize(rule:, user:)
        @rule = rule
        @user = user
      end

      def acquire_points!
        reward_transaction = user.reward_transactions.new(
          rewards_issuing_rule: rule,
          rewardable: rule.reward
        )
        
        validator = Validator.new(conditions: rule[:conditions], user:, reward_transaction:)
        return unless validator.validate!
      end
    end
  end
end
