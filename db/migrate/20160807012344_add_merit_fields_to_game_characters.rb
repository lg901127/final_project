class AddMeritFieldsToGameCharacters < ActiveRecord::Migration
  def change
    add_column :game_characters, :sash_id, :integer
  end
end
