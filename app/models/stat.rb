class Stat < ActiveRecord::Base
  has_many :game_character_attributes, dependent: :destroy
  has_many :game_characters, through: :game_character_attributes
  has_many :enemy_stats, dependent: :destroy
  has_many :enemies, through: :enemy_stats
  has_many :item_stats, dependent: :destroy
  has_many :items, through: :item_stats
  validates :name, presence: true, uniqueness: true
end
