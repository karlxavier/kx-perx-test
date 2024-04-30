class Reward < ApplicationRecord
  has_many :reward_transactions, as: :rewardable

  validates :name, presence: true
  validates :reward_points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  enum code: { 
    points100: "points100",
    coffee: "coffee", 
    rebate: "rebate", 
    movie: "movie",
    airport: "airport"
  }
end
