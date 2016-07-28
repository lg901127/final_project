class GameCharacterItem < ActiveRecord::Base
  belongs_to :game_character
  belongs_to :item

  def self.give_items_to_character(game_character, item)
    if game_character.items.count < 6
      self.create(game_character: game_character, item: item)
      game_character.update(gold: game_character.gold - item.price)
      true
    else
      false
    end
  end

end
