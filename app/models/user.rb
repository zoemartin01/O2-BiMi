class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true
  validates :room, presence: true
  validates :balance, presence: true, numericality: true
  validates :admin, inclusion: [true, false]
  validates :enabled, inclusion: [true, false]

  has_many :transactions, class_name: "Transaction", foreign_key: "user_id"
end
