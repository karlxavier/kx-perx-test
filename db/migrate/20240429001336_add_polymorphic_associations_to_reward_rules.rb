class AddPolymorphicAssociationsToRewardRules < ActiveRecord::Migration[7.0]
  def change
    add_reference :reward_transactions, :rewardable, polymorphic: true
    add_reference :rewards_issuing_rules, :reward, foreign_key: true, null: false
  end
end
