module Issuer
  class Base
    attr_accessor :scope, :rule, :conditions

    def initialize(scope:, rule:)
      @scope = scope
      @rule = rule
      @conditions = rule.conditions
    end

    def applicable?
      success = false

      conditions.each do |condition|
        actual_value = retrieval_call(commands: condition['field'], scope:)
        value = retrieval_call(commands: condition['value'])

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

    private

    def retrieval_call(commands:, scope: nil)
      method_chain = commands.split('.') if commands.is_a?(String)
      return commands if method_chain.blank?

      if scope
        method_chain.inject(scope) { |obj, method| obj.public_send(method) }
      elsif method_chain.size > 1
        eval(commands)
      else
        commands
      end
    end
  end
end