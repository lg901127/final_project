class CreateGameCharacterAttributes < ActiveRecord::Migration
  def change
    create_table :game_character_attributes do |t|
      t.references :game_character, index: true, foreign_key: true
      t.references :stat, index: true, foreign_key: true
      t.integer :value, default: 1

      t.timestamps null: false
    end
  end
end
