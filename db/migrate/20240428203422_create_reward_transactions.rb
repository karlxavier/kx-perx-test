class CreateRewardTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reward_transactions do |t|
      t.references :rewards_issuing_rule, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :state
      t.datetime :redeem_at

      t.timestamps
    end
  end
end
