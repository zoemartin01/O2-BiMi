class Admin::TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all.order(:created_at)
  end

  def show
    @transaction = Transaction.find(params[:id])
    render '/transactions/show'
  end

  def new
    @transaction = Transaction.new
  end

  def create
    drink_id = params[:transaction][:drink_id]
    if !!params[:restock]
      params[:transaction][:balance_change] = 0

      raise ArgumentError, "Must select a drink when restocking" if drink_id.empty?

      if params[:transaction][:comment].empty?
        params[:transaction][:comment] = "Drink Restock"
      end
    else
      if drink_id.nil? || drink_id.empty?
        params[:transaction][:stock_change] = "0"
        params[:transaction][:comment] = "Money Deposit"
      else
        drink = Drink.find(drink_id)
        new_balance = params[:transaction][:stock_change].to_i * drink.price
        params[:transaction][:balance_change] = new_balance
      end
    end

    @transaction = Transaction.new(transaction_params)

    if @transaction.save!
      user = @transaction.user
      new_balance = user.balance + @transaction.balance_change
      user.update(balance: new_balance)

      unless drink_id.nil? || drink_id.empty?
        drink = Drink.find(drink_id)
        new_stock = drink.stock + params[:transaction][:stock_change].to_i
        drink.update(stock: new_stock)
      end

      redirect_to @transaction
    else
      render :new
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    unless @transaction.drink.nil?
      drink = @transaction.drink
      new_stock = drink.stock - @transaction.stock_change
      drink.update(stock: new_stock)

      user = @transaction.user
      new_balance = user.balance - @transaction.balance_change
      user.update(balance: new_balance)
    end

    @transaction.destroy!
    redirect_to admin_transaction_path
  end

  private
  def transaction_params
    params.require(:transaction).permit(:stock_change, :balance_change, :comment,
                                        :drink_id, :user_id, :booked_by_id)
  end
end
