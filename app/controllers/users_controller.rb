class UsersController < ApplicationController
  def show
    if !params[:id].nil?
      @user = User.find(params[:id])
    else
      if logged_in?
        @user = User.find(session[:user_id])
      else
        redirect_to :login
      end
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  def create
    @user = User.new(user_params)
    @user.balance = 0
    @user.enabled = false
    @user.admin = false

    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :name, :room, :password, :password_confirmation)
  end
end
