class Item < ActiveRecord::Base
  has_many :item_stats, dependent: :destroy
  has_many :stats, through: :item_stats
  has_many :game_character_items, dependent: :destroy
  has_many :game_characters, through: :game_character_items
  validates :name, presence: true
end
