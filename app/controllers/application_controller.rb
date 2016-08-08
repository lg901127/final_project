class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def user_signed_in?
    session[:user_id].present?
  end
  helper_method :user_signed_in?

  def sign_in(user)
    session[:user_id] = user.id
  end

  def authenticate_user!
    redirect_to new_session_path, alert: "Please sign in" unless user_signed_in?
  end

  def authorize_owner
      redirect_to root_path, alert: "access denied" unless session[:user_id] = current_user.id
  end

  def badge_count(game_character)
    bronze_count = 0
    silver_count = 0
    gold_count = 0
    bronze_badge_url = "icons/green.png"
    silver_badge_url = "icons/grey.png"
    gold_badge_url = "icons/dark_yellow.png"
    game_character.badges.each do |badge|
      if badge.custom_fields[:difficulty] == :bronze
        bronze_count += 1
      elsif badge.custom_fields[:difficulty] == :silver
        silver_count += 1
      elsif badge.custom_fields[:difficulty] == :gold
        gold_count += 1
      end
    end
    {
      gold: {
        count: gold_count,
        url: gold_badge_url
      },
      silver: {
        count: silver_count,
        url: silver_badge_url
      },
      bronze: {
        count: bronze_count,
        url: bronze_badge_url
      }
    }
  end
  helper_method :badge_count

end
