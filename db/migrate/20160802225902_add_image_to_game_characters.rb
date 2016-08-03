class AddImageToGameCharacters < ActiveRecord::Migration
  def change
    add_column :game_characters, :image, :string
  end
end
