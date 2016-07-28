class EnemyStat < ActiveRecord::Base
  belongs_to :enemy
  belongs_to :stat
end
