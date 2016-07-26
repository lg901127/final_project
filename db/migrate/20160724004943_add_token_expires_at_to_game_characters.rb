class AddTokenExpiresAtToGameCharacters < ActiveRecord::Migration
  def change
    add_column :game_characters, :token_expires_at, :integer
  end
end
