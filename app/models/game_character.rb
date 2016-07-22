class GameCharacter < ActiveRecord::Base
  belongs_to :user
  has_many :game_character_attributes, dependent: :destroy
  has_many :stats, through: :game_character_attributes
  validates :name, presence: true
end
