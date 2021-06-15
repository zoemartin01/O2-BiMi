class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.belongs_to :user, references: :uuid, type: :string
      t.belongs_to :drink, references: :uuid, type: :string
      t.decimal :balance_change
      t.integer :stock_change
      t.string :comment

      t.datetime :created_at, null: false
    end
  end
end
