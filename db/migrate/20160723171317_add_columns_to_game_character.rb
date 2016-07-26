class AddColumnsToGameCharacter < ActiveRecord::Migration
  def change
    add_column :game_characters, :uid, :string
    add_column :game_characters, :provider, :string
    add_column :game_characters, :fitbit_token, :string
    add_column :game_characters, :fitbit_raw_data, :text
  end
end
