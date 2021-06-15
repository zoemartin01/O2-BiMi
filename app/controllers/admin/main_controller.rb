class Admin::MainController < ApplicationController
  def index
    @low_stock = Drink.all.order(:stock).limit(5)
    @low_balance = User.all.order(:balance).limit(5)
  end
end
