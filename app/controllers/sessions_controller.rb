class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to user_path
    end
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.signed[:user_id] = { value: user.id, expires: 2.weeks.from_now }
      else
        cookies.signed[:user_id] = user.id
      end
      redirect_to user_path
      flash[:success] = "Successfully logged in!"
    else
      redirect_to login_path
      flash[:danger] = "Login failed!"
    end
  end

  def destroy
    cookies.delete :user_id
    redirect_to login_path
    flash[:success] = "Successfully logged out!"
  end
end
