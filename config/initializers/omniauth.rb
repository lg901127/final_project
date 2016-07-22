Rails.application.config.middleware.use OmniAuth::Builder do
  provider :fitbit_oauth2, ENV['FITBIT_CLIENT_ID'], ENV['FITBIT_CLIENT_SECRET'],
  :scope => 'profile', :expires_in => '2592000', :prompt => 'login', :response_type => 'token', :provider_ignores_state => true
end
