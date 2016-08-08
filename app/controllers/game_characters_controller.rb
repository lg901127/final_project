class GameCharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_owner
  def index
    user = User.find_by_id params[:user_id]
    @game_character = user.game_character
    items_info = char_items(@game_character)
    strength = parse_strength(@game_character)
    constitution = parse_constitution(@game_character)
    respond_to do |format|
      format.json { render json: {
                                  character_items: items_info,
                                  character_strength: strength,
                                  character_constitution: constitution,
                                  gold: @game_character.gold
                                  } }
    end
  end

  def show
    @game_character = GameCharacter.find params[:id]
    @game_character_items = @game_character.game_character_items
    $strength_xp_cost = @game_character.game_character_attributes.find_by_stat_id(13).value * 10
    $constitution_xp_cost = @game_character.game_character_attributes.find_by_stat_id(14).value * 10
    time_info = char_xp_gold_calculation(@game_character)
    series_info = char_data_series(@game_character)
    char_energy_calculation(@game_character, time_info)
    @pie_chart = pie_chart(time_info)
    @chart = area_chart(series_info)
  end

  def new
  end

  def create
    #This should create a character with 0 xp and gold, all default values, character gets exp etc when login
  end

  def destroy
  end

  def update
    image_params = params.require(:game_character).permit(:image)
    game_character = GameCharacter.find params[:id]
    game_character.update(image: image_params["image"])
    redirect_to user_path(current_user)
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

  def char_data_series(game_character)
    token = game_character.fitbit_token
    t = Time.now.strftime "%Y-%m-%d"
    calories_series_url = "https://api.fitbit.com/1/user/-/activities/calories/date/#{t}/7d.json"
    steps_series_url = "https://api.fitbit.com/1/user/-/activities/steps/date/#{t}/7d.json"
    conn_calories = Faraday.new(:url => calories_series_url) {|faraday| faraday.request :url_encoded; faraday.response :logger; faraday.adapter Faraday.default_adapter }
    resp_calories = conn_calories.get { |req| req.headers['Authorization'] = "Bearer #{token}"}
    conn_steps = Faraday.new(:url => steps_series_url) {|faraday| faraday.request :url_encoded; faraday.response :logger; faraday.adapter Faraday.default_adapter }
    resp_steps = conn_steps.get { |req| req.headers['Authorization'] = "Bearer #{token}"}
    calories_info = JSON.parse(resp_calories.body)
    steps_info = JSON.parse(resp_steps.body)
    [calories_info, steps_info]
  end

  def char_active_time(game_character)
    token = game_character.fitbit_token
    t = Time.now.strftime "%Y-%m-%d"
    u = "https://api.fitbit.com/1/user/-/activities/date/#{t}.json"
    conn = Faraday.new(:url => u) {|faraday| faraday.request :url_encoded; faraday.response :logger; faraday.adapter Faraday.default_adapter }
    resp = conn.get { |req| req.headers['Authorization'] = "Bearer #{token}"}
    information = JSON.parse(resp.body)
    information
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

  def area_chart(series_info)
    chart = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = "area"
      f.options[:title][:text] = "Experience & Gold"
      f.options[:plotOptions] = {areaspline: {pointInterval: 1.day, pointStart: 10.days.ago}}
      f.series(:name=>'Experience(Calories)', :data=>[
                                      series_info[0]["activities-calories"][0]["value"].to_i / XP_GAINING_DENOMINATOR,
                                      series_info[0]["activities-calories"][1]["value"].to_i / XP_GAINING_DENOMINATOR,
                                      series_info[0]["activities-calories"][2]["value"].to_i / XP_GAINING_DENOMINATOR,
                                      series_info[0]["activities-calories"][3]["value"].to_i / XP_GAINING_DENOMINATOR,
                                      series_info[0]["activities-calories"][4]["value"].to_i / XP_GAINING_DENOMINATOR,
                                      series_info[0]["activities-calories"][5]["value"].to_i / XP_GAINING_DENOMINATOR,
                                      series_info[0]["activities-calories"][6]["value"].to_i / XP_GAINING_DENOMINATOR])
      f.series(:name=>'Gold(Steps)', :data=> [
                                      series_info[1]["activities-steps"][0]["value"].to_i / GOLD_GAINING_DEMONINATOR,
                                      series_info[1]["activities-steps"][1]["value"].to_i / GOLD_GAINING_DEMONINATOR,
                                      series_info[1]["activities-steps"][2]["value"].to_i / GOLD_GAINING_DEMONINATOR,
                                      series_info[1]["activities-steps"][3]["value"].to_i / GOLD_GAINING_DEMONINATOR,
                                      series_info[1]["activities-steps"][4]["value"].to_i / GOLD_GAINING_DEMONINATOR,
                                      series_info[1]["activities-steps"][5]["value"].to_i / GOLD_GAINING_DEMONINATOR,
                                      series_info[1]["activities-steps"][6]["value"].to_i / GOLD_GAINING_DEMONINATOR])
      f.xAxis(categories: [
                            series_info[0]["activities-calories"][0]["dateTime"],
                            series_info[0]["activities-calories"][1]["dateTime"],
                            series_info[0]["activities-calories"][2]["dateTime"],
                            series_info[0]["activities-calories"][3]["dateTime"],
                            series_info[0]["activities-calories"][4]["dateTime"],
                            series_info[0]["activities-calories"][5]["dateTime"],
                            series_info[0]["activities-calories"][6]["dateTime"]
                            ])
    end
    chart
  end

  def pie_chart(information)
    pie_chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 200, 60, 170]})
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
      f.options[:backgroundColor] = "transparent"
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
    pie_chart
  end

  def char_energy_calculation(game_character, information)
    sedentary_minutes = information["summary"]["sedentaryMinutes"]
    if sedentary_minutes >= game_character.sedentary_minutes
      if game_character.energy < 100
        energy_recovery = (sedentary_minutes - game_character.sedentary_minutes) / SEDENTARY_MINUTES_TO_ENERGY_RATIO
      else
        energy_recovery = 0
      end
      game_character.update(sedentary_minutes: sedentary_minutes, energy: game_character.energy + energy_recovery) if energy_recovery > 0
    else
      game_character.update(sedentary_minutes: sedentary_minutes, energy: 100)
    end
  end

  def char_items(game_character)
    items_info = []
    game_character.game_character_items.each do |item|
      item_info = {
        id: item.id,
        name: Item.find(item.item_id).name,
        description: Item.find(item.item_id).description,
        url: Item.find(item.item_id).image.url(:small)
      }
      Item.find(item.item_id).item_stats.each do |stat|
        name = Stat.find(stat.stat_id).name
        item_info[name] = stat.value
      end
      items_info << item_info
    end
    items_info
  end

end
