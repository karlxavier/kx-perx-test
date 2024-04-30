class RewardTransaction < ApplicationRecord
  belongs_to :rewardable, polymorphic: true
  belongs_to :rewards_issuing_rule
  belongs_to :user

  has_and_belongs_to_many :point_transactions

  before_save :set_redeem_at, if: -> { self.redeemed? }

  include AASM

  aasm whiny_transitions: false, column: :state do
    state :available, initial: true
    state :redeemed

    event :redeem do
      transitions from: :available, to: :redeemed
    end
  end

  private

  def set_redeem_at
    self.redeem_at = Time.now.utc
  end
end
