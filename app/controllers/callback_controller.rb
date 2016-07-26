class CallbackController < ApplicationController

  def fitbit
    fitbit_oauth2_data = request.env['omniauth.auth']
    game_character = GameCharacter.find_or_create_from_fitbit fitbit_oauth2_data #future modification required for expired token
    redirect_to user_game_character_path(current_user, game_character)
  end


end
# t = Time.now.strftime "%Y-%m-%d"
# u = "https://api.fitbit.com/1/user/-/activities/date/#{t}.json"
# conn = Faraday.new(:url => u) {|faraday| faraday.request :url_encoded; faraday.response :logger; faraday.adapter Faraday.default_adapter }
# resp = conn.get { |req| req.headers['Authorization'] = "Bearer #{token}"}
# game_character = GameCharacter.find_or_create_from_fitbit fitbit_oauth2_data
# token = fitbit_oauth2_data.credentials.token
# # render json: fitbit_oauth2_data
