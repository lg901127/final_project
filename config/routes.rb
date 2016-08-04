Rails.application.routes.draw do
  root "home#index"
  get '/auth/:provider/callback' => 'callback#fitbit'
  get '/auth/fitbit_oauth2', as: :signin_with_fitbit

  resources :users do
    resources :game_characters do
      put '/add_strength' => 'game_characters#add_strength', as: :add_strength
      put '/add_constitution' => 'game_characters#add_constitution', as: :add_constitution
      get '/show_character' => 'game_character#show', as: :show_character
      resources :enemies, only: [:index, :show]
      resources :player_challenges, only: [:index, :show]#, defaults: {format: :json}
    end
    resources :items do
      post '/game_character_items' => 'game_character_items#create'
    end
  end

  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end
  delete '/users/:user_id/game_characters/:game_character_id/game_character_items/:id' => 'game_character_items#destroy'


end
