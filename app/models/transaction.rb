class Transaction < ApplicationRecord
  belongs_to :user
  has_one :point_transaction

  validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_create :calculate_points
  after_update :recalculate_points, if: -> { saved_change_to_amount? }

  include AASM

  aasm whiny_transitions: false, column: :state do
    state :pending, initial: true
    state :calculated
    state :used

    event :calculate do
      transitions from: :pending, to: :calculated
    end

    event :use do
      transitions from: :calculated, to: :used
    end
  end

  private

  def calculate_points
    CalculatePointsWorker.perform_async(self.id)
  end

  def recalculate_points
    RecalculatePointsWorker.perform_async(self.id)
  end
end
