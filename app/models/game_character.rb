class GameCharacter < ActiveRecord::Base
  has_merit

  belongs_to :user
  has_many :game_character_attributes, dependent: :destroy
  has_many :stats, through: :game_character_attributes
  has_many :game_character_items, dependent: :destroy
  has_many :items, through: :game_character_items
  validates :name, presence: true

  mount_uploader :image, ImageUploader

  def self.find_or_create_from_fitbit(fitbit_data)
    game_character = GameCharacter.where(uid: fitbit_data.uid).first
    game_character = create_from_fitbit(fitbit_data) unless game_character
    if Time.at(game_character.token_expires_at) - Time.now > 0
      game_character
    else
      new_token = fitbit_data.credentials.token
      game_character.update(fitbit_token: new_token)
      game_character
    end
  end

  def self.create_from_fitbit(fitbit_data)
    game_character = GameCharacter.new
    game_character.name = fitbit_data.info.full_name
    game_character.uid = fitbit_data.uid
    game_character.provider = fitbit_data.provider
    game_character.fitbit_token = fitbit_data.credentials.token
    game_character.fitbit_raw_data = fitbit_data
    game_character.user = User.find_by_full_name fitbit_data.info.full_name
    game_character.token_expires_at = fitbit_data.credentials.expires_at
    game_character.save!
    strength = Stat.find_by_name ("Strength")
    constitution = Stat.find_by_name ("Constitution")
    GameCharacterAttribute.create(game_character: game_character, stat: strength)
    GameCharacterAttribute.create(game_character: game_character, stat: constitution)
    game_character
  end
end
