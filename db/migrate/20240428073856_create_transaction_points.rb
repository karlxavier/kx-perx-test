class CreateTransactionPoints < ActiveRecord::Migration[7.0]
  def change
    create_table :point_transactions do |t|
      t.references :points_issuing_rule, null: false, foreign_key: true
      t.references :transaction, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :state
      t.datetime :expires_at
      t.datetime :used_at
      t.integer :current_points, default: 0
      t.integer :total_points, default: 0

      t.timestamps
    end
  end
end
