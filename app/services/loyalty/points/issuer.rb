module Loyalty
  module Points
    class Issuer
      class PointsIssuanceError < StandardError; end

      attr_accessor :transaction

      def initialize(transaction:)
        @transaction = transaction
      end

      def call
        calculation_issuing_rules.each do |rule|
          validator = Validator.new(transaction:, rule:)
          next unless validator.applicable?
  
          point_transaction = validator.build_transacton_point
  
          raise PointsIssuanceError if point_transaction.used?
  
          points_gained = validator.points_gained
          point_transaction.total_points = points_gained
          point_transaction.current_points = points_gained
          transaction.calculate! if point_transaction.save
        end
      end

      private

      def calculation_issuing_rules
        @calculation_issuing_rules ||= PointsIssuingRule.active
      end
    end
  end
end
