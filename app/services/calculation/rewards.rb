module Calculation
  class Rewards
    attr_accessor :user_id

    def initialize(user_id:)
      @user_id = user_id
    end

    def calculate!
      calculation_issuing_rules.each do |rule|
        issuer = Issuer::Rewards.new(scope:, rule:)
        next unless issuer.applicable?

        raise CalculationError if point_transaction.used?

        point_transaction.points = issuer.points_gained
        transaction.calculate! if point_transaction.save
      end
    end

    private

    def calculation_issuing_rules
      @calculation_issuing_rules ||= RewardsIssuingRule.active
    end

    def set_scope
      
    end
  end
end
