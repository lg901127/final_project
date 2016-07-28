class GameCharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_owner
  def index
    user = User.find_by_id params[:user_id]
    @game_character = user.game_character
  end

  def show
    @game_character = GameCharacter.find params[:id]
    $strength_xp_cost = @game_character.game_character_attributes.find_by_stat_id(13).value * 10
    $constitution_xp_cost = @game_character.game_character_attributes.find_by_stat_id(14).value * 10
    information = char_xp_gold_calculation(@game_character)
    char_energy_calculation(@game_character, information)
    @chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 200, 60, 170]} )
      series = {
               :type=> 'pie',
               :name=> 'Browser share',
               :data=> [
                  ['Fairly Active Mins', information["summary"]["fairlyActiveMinutes"]],
                  ['Lightly Active Mins', information["summary"]["lightlyActiveMinutes"]],
                  {
                     :name=> 'Sedentary Mins',
                     :y=> information["summary"]["sedentaryMinutes"],
                     :sliced=> true,
                     :selected=> true
                  },
                  ['Very Active Mins', information["summary"]["veryActiveMinutes"]]
               ],
               :size => "100%",
    :innerSize => "40%"
      }
      f.series(series)
      f.options[:title][:text] = "Active Time Summary"
      f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'})
      f.plot_options(:pie=>{
        :allowPointSelect=>true,
        :cursor=>"pointer" ,
        :dataLabels=>{
          :enabled=>true,
          :color=>"black",
          :style=>{
            :font=>"13px Trebuchet MS, Verdana, sans-serif"
          }
        }
      })
    end
  end

  def new
  end

  def create
    #This should create a character with 0 xp and gold, all default values, character gets exp etc when login
  end

  def destroy
  end

  def add_strength
    @game_character = GameCharacter.find params[:game_character_id]
    if @game_character.xp > $strength_xp_cost
      strength = @game_character.game_character_attributes.find_by_stat_id(13).value
      @game_character.game_character_attributes.find_by_stat_id(13).update(value: strength + 1)
      @game_character.update(xp: @game_character.xp - $strength_xp_cost, level: char_level_calculation($strength_xp_cost, $constitution_xp_cost))
      redirect_to user_game_character_path(current_user, @game_character)
    else
      redirect_to user_game_character_path(current_user, @game_character), notice: "EXP not enough!!!"
    end
  end

  def add_constitution
    @game_character = GameCharacter.find params[:game_character_id]
    if @game_character.xp > $constitution_xp_cost
      constitution = @game_character.game_character_attributes.find_by_stat_id(14).value
      @game_character.game_character_attributes.find_by_stat_id(14).update(value: constitution + 1)
      @game_character.update(xp: @game_character.xp - $constitution_xp_cost, level: char_level_calculation($strength_xp_cost, $constitution_xp_cost))
      redirect_to user_game_character_path(current_user, @game_character)
    else
      redirect_to user_game_character_path(current_user, @game_character), notice: "EXP not enough!!!"
    end
  end

  def item_name(item)
    i = Item.find item.item_id
    i.name
  end
  helper_method :item_name

  def item_description(item)
    i = Item.find item.item_id
    i.description
  end
  helper_method :item_description

  def parse_strength(game_character)
    GameCharacterStatCalculator.new(game_character).parse_strength
  end
  helper_method :parse_strength

  def parse_constitution(game_character)
    GameCharacterStatCalculator.new(game_character).parse_constitution
  end
  helper_method :parse_constitution

  private

  XP_GAINING_DENOMINATOR = 2
  GOLD_GAINING_DEMONINATOR = 6

  SEDENTARY_MINUTES_TO_ENERGY_RATIO = 5

  def char_level_calculation(strength_xp_cost, constitution_xp_cost)
    return (strength_xp_cost + constitution_xp_cost)/ 10 / 4
  end

  def char_xp_gold_calculation(game_character)
    token = game_character.fitbit_token
    t = Time.now.strftime "%Y-%m-%d"
    u = "https://api.fitbit.com/1/user/-/activities/date/#{t}.json"
    conn = Faraday.new(:url => u) {|faraday| faraday.request :url_encoded; faraday.response :logger; faraday.adapter Faraday.default_adapter }
    resp = conn.get { |req| req.headers['Authorization'] = "Bearer #{token}"}
    information = JSON.parse(resp.body)
    calories = information["summary"]["caloriesOut"]
    steps = information["summary"]["steps"]
    if game_character.xp == 0
      game_character.update(calories: calories, steps: steps, xp: 1)
    else
      # if game_character.updated_at.today?
      if calories - game_character.calories >= 0
        xp_gain = (calories - game_character.calories)/XP_GAINING_DENOMINATOR
        gold_gain = (steps - game_character.steps)/GOLD_GAINING_DEMONINATOR
        game_character.update(xp: game_character.xp + xp_gain, gold: game_character.gold + gold_gain, calories: calories, steps: steps)
      else
        yesterday = (Time.now - 1.day).strftime "%Y-%m-%d"
        u = "https://api.fitbit.com/1/user/-/activities/date/#{yesterday}.json"
        conn = Faraday.new(:url => u) {|faraday| faraday.request :url_encoded; faraday.response :logger; faraday.adapter Faraday.default_adapter }
        resp = conn.get { |req| req.headers['Authorization'] = "Bearer #{token}"}
        information_yesterday = JSON.parse(resp.body)
        calories_yesterday = information_yesterday["summary"]["caloriesOut"]
        steps_yesterday = information_yesterday["summary"]["steps"]
        xp_gain = (calories_yesterday - game_character.calories + calories)/XP_GAINING_DENOMINATOR
        gold_gain = (steps_yesterday - game_character.steps + steps)/GOLD_GAINING_DEMONINATOR
        game_character.update(xp: game_character.xp + xp_gain, gold: game_character.gold + gold_gain, calories: calories, steps: steps)
      end
    end
    information
  end

  def char_energy_calculation(game_character, information)
    sedentary_minutes = information["summary"]["sedentaryMinutes"]
    energy_recovery = 0
    if sedentary_minutes >= game_character.sedentary_minutes
      energy_recovery = (sedentary_minutes - game_character.sedentary_minutes) / SEDENTARY_MINUTES_TO_ENERGY_RATIO if game_character.energy < 100
      game_character.update(sedentary_minutes: sedentary_minutes, energy: game_character.energy + energy_recovery)
    else
      game_character.update(sedentary_minutes: sedentary_minutes, energy: 100)
    end
  end

end
