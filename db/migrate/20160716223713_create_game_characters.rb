class CreateGameCharacters < ActiveRecord::Migration
  def change
    create_table :game_characters do |t|
      t.string :name
      t.integer :level, default: 1
      t.integer :xp, default: 0
      t.integer :gold, default: 0
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
