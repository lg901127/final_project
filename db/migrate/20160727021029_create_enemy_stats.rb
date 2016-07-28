class CreateEnemyStats < ActiveRecord::Migration
  def change
    create_table :enemy_stats do |t|
      t.references :enemy, index: true, foreign_key: true
      t.references :stat, index: true, foreign_key: true
      t.integer :value, default: 1
      t.timestamps null: false
    end
  end
end
