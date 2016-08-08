class CallbackController < ApplicationController

  def fitbit
    fitbit_oauth2_data = request.env['omniauth.auth']
    game_character = GameCharacter.find_or_create_from_fitbit fitbit_oauth2_data #future modification required for expired token
    redirect_to user_game_character_path(current_user, game_character)
  end
  
end
