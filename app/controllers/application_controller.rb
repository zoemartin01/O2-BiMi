class ApplicationController < ActionController::Base
  def logged_in?
    !current_user.nil?
  end

  def admin?
    if logged_in?
      current_user.admin
    end
  end
  helper_method :admin?

  def current_user
    @current_user ||= User.find(cookies.signed[:user_id]) if cookies.signed[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to login_path unless current_user
  end
end
