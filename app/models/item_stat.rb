class ItemStat < ActiveRecord::Base
  belongs_to :item
  belongs_to :stat
end
