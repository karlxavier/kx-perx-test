class CreateRewardsIssuingRules < ActiveRecord::Migration[7.0]
  def change
    create_table :rewards_issuing_rules do |t|
      t.jsonb :conditions, default: [{}]
      t.string :state

      t.timestamps
    end
  end
end
