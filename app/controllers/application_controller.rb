class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  helper_method :current_user
  helper_method :avatar_url
 
  private
 
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def avatar_url
    current_user.github_client.user[:avatar_url]
  end

  def not_found
    raise ActiveRecord::RecordNotFound
  end

  def redirect_to_root_page_if_logged_out
    return if current_user
    redirect_to root_path, alert: 'You have to be logged in to use this feature.'
  end

end
