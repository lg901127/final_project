class CreateItemStats < ActiveRecord::Migration
  def change
    create_table :item_stats do |t|
      t.references :item, index: true, foreign_key: true
      t.references :stat, index: true, foreign_key: true
      t.integer :value, default: 0
      t.timestamps null: false
    end
  end
end
