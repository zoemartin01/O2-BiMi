class Admin::DrinksController < ApplicationController
  def index
    @drinks = Drink.all
  end

  def show
    @drink = Drink.find(params[:id])
  end

  def new
    @drink = Drink.new
  end

  def create
    @drink = Drink.new(drink_params)

    if @drink.save
      redirect_to admin_drink_path(@drink)
    else
      render :new
    end
  end

  def edit
    @drink = Drink.find(params[:id])
  end

  def update
    @drink = Drink.find(params[:id])

    if @drink.update(drink_params)
      redirect_to admin_drink_path(@drink)
      flash[:success] = "Drink successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @drink = Drink.find(params[:id])
    @drink.destroy

    redirect_to admin_drink_path
  end


  private
  def drink_params
    params.require(:drink).permit(:name, :price, :stock, :enabled)
  end
end
