class AddEnergyAndSedentaryMinutesToGameCharacter < ActiveRecord::Migration
  def change
    add_column :game_characters, :energy, :integer, default: 100
    add_column :game_characters, :sedentary_minutes, :integer, default: 0
  end
end
