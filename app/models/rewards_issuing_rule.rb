class RewardsIssuingRule < ApplicationRecord
  belongs_to :reward
  has_many :reward_transactions

  include AASM

  aasm whiny_transitions: true, column: :state do
    state :active, initial: true
    state :inactive

    event :deactivate do
      transitions from: :active, to: :inactive
    end

    event :activate do
      transitions from: :inactive, to: :active
    end
  end
end
