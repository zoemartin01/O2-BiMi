class Drink < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0, message: "Must be a number greater than 0" }
  validates :stock, presence: true, numericality: { greater_than: 0, message: "Must be a number greater than 0" }
  validates :enabled, inclusion: [true, false]

  has_many :transactions, class_name: "Transaction", foreign_key: "drink_id"
end
