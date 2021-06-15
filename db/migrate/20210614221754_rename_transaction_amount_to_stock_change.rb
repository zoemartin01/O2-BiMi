class RenameTransactionAmountToStockChange < ActiveRecord::Migration[6.1]
  def change
    rename_column :transactions, :stock_change, :stock_change
  end
end
