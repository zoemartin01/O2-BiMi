class CreateDrinks < ActiveRecord::Migration[6.1]
  def change
    create_table :drinks, id: :uuid do |t|
      t.string :name
      t.decimal :price
      t.integer :stock

      t.timestamps
    end
  end
end
