Rails.application.routes.draw do
  root "home#index"
  get '/auth/:provider/callback' => 'callback#fitbit'
  get '/auth/fitbit_oauth2', as: :signin_with_fitbit

  resources :users do
    resources :game_characters do
      put '/add_strength' => 'game_characters#add_strength', as: :add_strength
      put '/add_constitution' => 'game_characters#add_constitution', as: :add_constitution
    end
  end

  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end
end
