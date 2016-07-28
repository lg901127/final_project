class CreateEnemies < ActiveRecord::Migration
  def change
    create_table :enemies do |t|
      t.string :name
      t.integer :level
      t.integer :xp
      t.integer :gold

      t.timestamps null: false
    end
  end
end
