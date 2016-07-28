class GameCharacterStatCalculator
  attr_reader :game_character

  def initialize(game_character)
    @game_character = game_character
  end

  def parse_strength
    game_character_strength = game_character.game_character_attributes.find_by_stat_id(13).value
    game_character_item_strength = 0
    game_character.game_character_items.each do |item|
      game_character_item_strength = game_character_item_strength + ItemStat.where(item_id: item.item_id).find_by_stat_id(13).value if ItemStat.where(item_id: item.item_id).find_by_stat_id(13)
    end
    game_character_strength + game_character_item_strength
  end

  def parse_constitution
    game_character_constitution = game_character.game_character_attributes.find_by_stat_id(14).value
    game_character_item_constitution = 0
    game_character.game_character_items.each do |item|
      game_character_item_constitution = game_character_item_constitution + ItemStat.where(item_id: item.item_id).find_by_stat_id(14).value if ItemStat.where(item_id: item.item_id).find_by_stat_id(14)
    end
    game_character_constitution + game_character_item_constitution
  end

end
