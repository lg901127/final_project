class EnemiesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_owner

  CONSTITUTION_TO_HP_RATIO = 10

  def index
    @enemies = Enemy.order("level")
    @game_character = GameCharacter.find params[:game_character_id]
    respond_to do |format|
      format.html
      format.json { render json: {enemies: @enemies,
                                  game_character: @game_character
                                  }}
    end
  end

  def show
    @enemy = Enemy.find params[:id]
    game_character = GameCharacter.find params[:game_character_id]
    if game_character.energy >= @enemy.level
      @battle_info = []
      game_character_hp = GameCharacterStatCalculator.new(game_character).parse_constitution * CONSTITUTION_TO_HP_RATIO
      game_character_strength = GameCharacterStatCalculator.new(game_character).parse_strength
      enemy_hp = EnemyStatCalculator.new(@enemy).parse_constitution * CONSTITUTION_TO_HP_RATIO
      enemy_strength = EnemyStatCalculator.new(@enemy).parse_strength
      while game_character_hp >= 0 && enemy_hp >= 0
        hp_values = battle(game_character_strength, game_character_hp, enemy_hp, enemy_strength)
        game_character_hp = hp_values[0]
        enemy_hp = hp_values[1]
        if game_character_hp <= 0
          @battle_info << "Your HP: 0, Enemy HP: #{enemy_hp}"
        elsif enemy_hp <= 0
          @battle_info << "Your HP: #{game_character_hp}, Enemy HP: 0"
        else
          @battle_info << "Your HP: #{game_character_hp}, Enemy HP: #{enemy_hp}"
        end
      end
      if game_character_hp > 0
        @battle_info << "You Win!, you earned: #{@enemy.xp} EXP and #{@enemy.gold} Gold!"
        game_character.update(xp: game_character.xp + @enemy.xp, gold: game_character.gold + @enemy.gold, energy: game_character.energy - @enemy.level)
      else
        @battle_info << "You Lose!"
        game_character.update(energy: game_character.energy - @enemy.level)
      end
    else
      redirect_to user_game_character_enemies_path(current_user, game_character), alert: "Your energy is to low! Go get some rest!"
    end
  end

  private

  def battle(game_character_strength, game_character_hp, enemy_hp, enemy_strength)
    enemy_hp = enemy_hp - (game_character_strength * rand(0.7..1)).floor
    if enemy_hp >= 0
      game_character_hp = game_character_hp - (enemy_strength * rand(0.7..1)).floor
      return [game_character_hp, enemy_hp]
    else
      return [game_character_hp, enemy_hp]
    end
  end

end
