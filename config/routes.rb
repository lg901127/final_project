Rails.application.routes.draw do
  get '/auth/:provider/callback' => 'callback#index'
  get '/auth/fitbit_oauth2', as: :signin_with_fitbit
end
