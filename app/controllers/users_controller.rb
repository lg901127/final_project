class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :authorize_owner, only: [:show]
  def show
    @user = User.find params[:id]
    @game_character = @user.game_character if @user.game_character
  end

  def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
    @user = User.new user_params
    if @user.save
      # session[:user_id] = @user.id
      sign_in(@user)
      redirect_to root_path, notice: "You are now signed in!"
    else
      render :new
    end
  end

end