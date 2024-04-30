module Calculation
  class Base
    class CalculationError < StandardError; end

    attr_reader :scope

    def self.calculate!(scope:)
      ActiveRecord::Base.transaction do
        new(scope:).calculate!
      end
    end

    def initialize(scope:)
      @scope = scope
    end
  end
end
