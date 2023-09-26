class Product < ApplicationRecord
  belongs_to :category
  has_many :product_images, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :order_products, dependent: :destroy
  has_many :ratings, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates :description, presence: true
end
