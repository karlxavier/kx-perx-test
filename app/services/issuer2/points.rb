module Issuer
  class Points < Base
    def build_transacton_point
      if scope.pending?
        scope.build_point_transaction(
          points_issuing_rule_id: rule.id,
          user_id: scope.user_id
        )
      else
        scope.point_transaction
      end
    end

    def points_gained
      result = 0

      rule.calculations.each do |calculation|
        actual_value = retrieval_call(commands: calculation['field'], scope:)
        value = retrieval_call(commands: calculation['value'])
    
        case calculation['operator']
        when '/'
          result = actual_value / value
        else
          raise ArgumentError, "Unsupported operator: #{operator}"
        end
      end

      return result
    end
  end
end
