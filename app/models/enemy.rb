class Enemy < ActiveRecord::Base
  has_many :enemy_stats, dependent: :destroy
  has_many :stats, through: :enemy_stats
end
