class AddBookedByToTransaction < ActiveRecord::Migration[6.1]
  def change
    add_reference :transactions, :booked_by, index: true, type: :string
  end
end
