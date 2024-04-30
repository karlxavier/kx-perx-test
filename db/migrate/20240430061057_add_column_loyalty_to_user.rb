class AddColumnLoyaltyToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :loyalty_tier, :string, null: false
  end
end
