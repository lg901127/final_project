class EnemyStatCalculator
  attr_reader :enemy

  def initialize(enemy)
    @enemy = enemy
  end

  def parse_strength
    enemy_strength = enemy.enemy_stats.find_by_stat_id(13).value
    enemy_strength
  end

  def parse_constitution
    enemy_constitution = enemy.enemy_stats.find_by_stat_id(14).value
    enemy_constitution
  end

end
