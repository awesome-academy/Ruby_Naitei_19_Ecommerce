class Order < ApplicationRecord
  belongs_to :user
  scope :newest, ->{order(created_at: :desc)}
  has_many :products, dependent: :destroy
  has_many :order_products, dependent: :destroy
end
