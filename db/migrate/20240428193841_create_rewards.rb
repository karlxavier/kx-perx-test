class CreateRewards < ActiveRecord::Migration[7.0]
  def change
    create_table :rewards do |t|
      t.string :name
      t.string :code
      t.integer :reward_points, default: 0

      t.timestamps
    end
  end
end
