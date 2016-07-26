class User < ActiveRecord::Base
  has_secure_password
  has_one :game_character
  validates :full_name, presence: true

  
end
