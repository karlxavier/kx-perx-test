class CreatePointRewardTransactions < ActiveRecord::Migration[7.0]
  def change
    create_join_table :reward_transactions, :point_transactions do |t|
      
    end
  end
end
