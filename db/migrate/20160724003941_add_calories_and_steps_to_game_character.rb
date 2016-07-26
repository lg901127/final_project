class AddCaloriesAndStepsToGameCharacter < ActiveRecord::Migration
  def change
    add_column :game_characters, :calories, :integer
    add_column :game_characters, :steps, :integer
  end
end
