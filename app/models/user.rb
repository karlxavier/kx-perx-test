class User < ApplicationRecord
  TIER_GOLD_POINTS = 1000
  TIER_PLATINUM_POINTS = 5000

  has_many :transactions
  has_many :point_transactions
  has_many :reward_transactions

  include AASM

  aasm whiny_transitions: false, column: :loyalty_tier do
    state :standard, initial: true
    state :gold
    state :platinum

    event :to_gold do
      transitions from: :standard, to: :gold, guard: :valid_tier_points?
    end

    event :to_platinum do
      transitions from: :gold, to: :platinum, guard: :valid_tier_points?
    end
  end

  def update_loyalty_tier!
    self.to_gold!(tier: :gold)
    self.to_platinum!(tier: :platinum)
  end

  def valid_tier_points?(tier:)
    if tier == :gold
      all_points >= TIER_GOLD_POINTS
    elsif tier == :platinum
      all_points >= TIER_PLATINUM_POINTS
    end
  end

  def all_points
    point_transactions.sum(:total_points)
  end

  def available_points
    point_transactions.available.sum(:total_points)
  end

  def used_points
    point_transactions.used.sum(:total_points)
  end
end
