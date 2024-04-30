class CreatePointsIssuingRules < ActiveRecord::Migration[7.0]
  def change
    create_table :points_issuing_rules do |t|
      t.jsonb :conditions, default: [{}]
      t.jsonb :calculations, default: [{}]
      t.string :state

      t.timestamps
    end
  end
end
