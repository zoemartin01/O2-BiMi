class Transaction < ApplicationRecord
  validates :user_id, presence: true
  validates :stock_change, presence: true, numericality: true
  validates :balance_change, presence: true, numericality: true

  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :booked_by, class_name: "User", foreign_key: "booked_by_id"
  belongs_to :drink, class_name: "Drink", foreign_key: "drink_id", optional: true
end
