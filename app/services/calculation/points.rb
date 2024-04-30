module Calculation
  class Points < Base
    def calculate!
      calculation_issuing_rules.each do |rule|
        issuer = Issuer::Points.new(scope:, rule:)
        next unless issuer.applicable?

        point_transaction = issuer.build_transacton_point

        raise CalculationError if point_transaction.used?

        points_gained = issuer.points_gained
        point_transaction.total_points = points_gained
        point_transaction.current_points = points_gained
        scope.calculate! if point_transaction.save
      end
    end

    private

    def calculation_issuing_rules
      @calculation_issuing_rules ||= PointsIssuingRule.active
    end
  end
end
