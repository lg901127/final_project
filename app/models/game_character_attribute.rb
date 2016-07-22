class GameCharacterAttribute < ActiveRecord::Base
  belongs_to :game_character
  belongs_to :stat
end
