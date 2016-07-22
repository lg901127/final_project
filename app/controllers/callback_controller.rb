class CallbackController < ApplicationController

  def index
    omniauth_data =   request.env['omniauth.auth']
    render json: omniauth_data
  end

end
