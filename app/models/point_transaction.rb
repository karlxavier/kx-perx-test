class PointTransaction < ApplicationRecord
  belongs_to :points_issuing_rule
  belongs_to :user

  has_and_belongs_to_many :reward_transactions

  validates :total_points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :current_points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation :set_expiration_date, on: %i(create), if: -> { expires_at.nil? }
  before_validation :set_current_points, on: %i(create), if: -> { current_points.zero? }
  after_create :set_user_loyalty_tier

  include AASM

  aasm whiny_transitions: true, column: :state do
    state :available, initial: true
    state :used
    state :expired

    event :use do
      before do
        self.used_at = Time.now.utc
      end

      transitions from: :available, to: :used
    end

    event :expires do
      transitions to: :expired
    end
  end

  private

  def set_user_loyalty_tier
    user.update_loyalty_tier!
  end

  def set_expiration_date
    self.expires_at = 1.year.from_now.utc
  end

  def set_current_points
    self.current_points = self.total_points
  end
end
