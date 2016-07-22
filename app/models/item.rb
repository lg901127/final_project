class Item < ActiveRecord::Base
  has_many :item_stats, dependent: :destroy
  has_many :stats, through: :item_stats
  validates :name, presence: true
end
