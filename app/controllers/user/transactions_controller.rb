class User::TransactionsController < ApplicationController
  def index
    if logged_in?
      @transactions = User.find(session[:user_id]).transactions
    else
      redirect_to login_path
    end
  end

  def quick_buy
    if logged_in?
      if current_user.enabled
        @transaction = Transaction.new
        @transaction.drink = Drink.find(params[:drink_id])
        @transaction.user = current_user
        @transaction.booked_by = current_user
        @transaction.stock_change = -1 * params[:stock_change].to_i
        @transaction.comment = "Drink Quick Buy"
        @transaction.balance_change = @transaction.drink.price * @transaction.stock_change

        new_balance = current_user.balance + @transaction.balance_change

        if new_balance < 0
          redirect_to "/"
          flash[:danger] =  "Your balance is too low for this transaction!"
          return
        end

        drink = Drink.find(params[:drink_id])
        new_stock = drink.stock + @transaction.stock_change

        if @transaction.save
          current_user.update(balance: new_balance)
          drink.update(stock: new_stock)

          redirect_to @transaction
          flash[:success] = "Successfully bought '" + (@transaction.stock_change * -1).to_s + "' of '" + @transaction.drink.name + "'"
        else
          render :new
        end
      else
        redirect_to "/"
        flash[:danger] = "You cannot buy drinks because your account is not enabled yet. Please speak to an admin about it."
      end
    else
      redirect_to login_path
    end
  end

  def show
    if logged_in?
      @transaction = User.find(session[:user_id]).transactions.find([:id])
    else
      redirect_to login_path
    end
  end

  def new
    if logged_in?
      @transaction = Transaction.new
    else
      redirect_to login_path
    end
  end

  def create
    if logged_in?
      if current_user.enabled
        drink_id = params[:transaction][:drink_id]
        if drink_id.nil? || drink_id.empty?
          render :new
          flash[:error] = "Must select a drink!"
        end
        @transaction = Transaction.new(transaction_params)
        @transaction.stock_change *= -1
        @transaction.balance_change = @transaction.drink.price * @transaction.stock_change

        if @transaction.comment.nil? || @transaction.comment.empty?
          @transaction.comment = "Drink Purchase"
        end

        user = @transaction.user
        new_balance = user.balance + @transaction.balance_change

        if new_balance < 0
          redirect_to "/"
          flash[:danger] = (current_user == user ? "Your " : user.name + "'s ") + "balance is too low for this transaction!"
          return
        end

        drink = Drink.find(drink_id)
        new_stock = drink.stock - params[:transaction][:stock_change].to_i

        @transaction.booked_by = current_user

        if @transaction.save
          user.update(balance: new_balance)
          drink.update(stock: new_stock)

          redirect_to @transaction
          flash[:success] = "Successfully bought '" + (@transaction.stock_change * -1).to_s + "' of '" + @transaction.drink.name + "'"
        else
          render :new
        end
      else
        redirect_to "/"
        flash[:danger] = "You cannot buy drinks because your account is not enabled yet. Please speak to an admin about it."
      end
    else
      redirect_to login_path
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:stock_change, :balance_change, :comment, :drink_id, :user_id, :booked_by_id)
  end
end
