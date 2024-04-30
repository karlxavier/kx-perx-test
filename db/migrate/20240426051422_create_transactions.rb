class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount
      t.string :currency
      t.string :state

      t.timestamps
    end
  end
end
