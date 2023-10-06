class Order < ApplicationRecord
  belongs_to :user
  scope :newest, ->{order(created_at: :desc)}
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  enum :order_status, [:in_cart, :pending, :approved]
  scope :by_user_id, ->(user_id){where user_id:}
  scope :by_id, ->(id){where id:}
end
