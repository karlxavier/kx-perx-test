module Loyalty
  module Rewards
    class Validator
      attr_accessor :conditions, :user, :reward_transaction

      def initialize(conditions:, user:, reward_transaction:)
        @conditions = conditions
        @user = user
        @reward_transaction = reward_transaction
      end

      def validate!
        reward_scope = nil

        conditions.each do |condition|
          conditioner = Condition.new(condition:, user:)
          return false unless conditioner.success?

          if conditioner.reward_type.is_a?(PointTransaction)
            reward_scope = conditioner.points_transaction_scope
          end
        end

        confirm_reward(reward_scope:)
      end

      private

      def confirm_reward(reward_scope:)
        reward_transaction.save

        return if reward_scope.blank?
        reward_scope.each do |transaction|
          reward_transaction.point_transactions << transaction
          transaction.use
        end
      end
    end

    class Condition
      attr_accessor :condition, :user

      def initialize(condition:, user:)
        @condition = condition
        @user = user
      end

      def success?
        comparison = get_comparison_value

        case operator
        when '>='
          comparison >= should
        when '=='
          comparison == should
        else
          raise ArgumentError, "Unsupported operator: #{operator}"
        end
      end

      def points_transaction_scope
        @points_transaction_scope ||= begin

          case reward_type
          when PointTransaction
            scope = user.send(arg_table.underscore.pluralize).available
          when Transaction
            scope = user.send(arg_table.underscore.pluralize).calculated
          when User
            scope = user
          end

          scoped.blank? ? scope : scope.where(eval(scoped))
        end
      end

      def reward_type
        table_klass.new
      end

      private

      def get_comparison_value
        return false if points_transaction_scope.blank?

        comparison = if values.is_a?(Array)
          points_transaction_scope.send(values.first, values.last)
        else
          points_transaction_scope.send(values['caller']).send(values['extractor'])
        end

        comparison
      end

      def arg_table
        condition['table']
      end

      def table
        @table ||= arg_table.constantize.arel_table
      end

      def table_klass
        table.table_name.classify.constantize
      end

      def operator
        condition['operator']
      end

      def should
        eval(condition['should'])
      end

      def scoped
        condition['scoped']
      end

      def values
        condition['values']
      end
    end
  end
end
