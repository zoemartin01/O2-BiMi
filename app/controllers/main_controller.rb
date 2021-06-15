class MainController < ApplicationController
  def index
    unless logged_in?
      redirect_to '/login'
    end
  end

  def user
      if logged_in?
        @user = current_user
        render 'users/show'
      else
        redirect_to :login
      end
  end
end
