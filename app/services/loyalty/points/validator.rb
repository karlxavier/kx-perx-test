module Loyalty
  module Points
    class Validator
      attr_accessor :rule, :transaction, :conditions

      def initialize(transaction:, rule:)
        @transaction = transaction
        @rule = rule
        @conditions = rule[:conditions]
      end

      def applicable?
        success = false
  
        conditions.each do |condition|
          actual_value = transaction.send(condition['field'])
          value = condition['value']
  
          case condition['operator']
          when '=='
            success = actual_value == value
          when '!='
            success = actual_value != value
          else
            raise ArgumentError, "Unsupported operator: #{operator}"
          end
        end
  
        return success
      end

      def points_gained
        result = 0
  
        rule.calculations.each do |calculation|
          actual_value = transaction.send(calculation['field'])
          value = calculation['value']
      
          case calculation['operator']
          when '/'
            result = actual_value / value
          else
            raise ArgumentError, "Unsupported operator: #{operator}"
          end
        end
  
        return result
      end

      def build_transacton_point
        if transaction.pending?
          transaction.build_point_transaction(
            points_issuing_rule_id: rule.id,
            user_id: transaction.user_id
          )
        else
          transaction.point_transaction
        end
      end

    end
  end
end
