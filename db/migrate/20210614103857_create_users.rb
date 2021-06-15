class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :room
      t.decimal :balance
      t.string :password_digest
      t.boolean :enabled

      t.timestamps
    end
  end
end
