class CreateGameCharacterItems < ActiveRecord::Migration
  def change
    create_table :game_character_items do |t|
      t.references :game_character, index: true, foreign_key: true
      t.references :item, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
