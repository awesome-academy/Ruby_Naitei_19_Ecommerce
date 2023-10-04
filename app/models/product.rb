class Product < ApplicationRecord
  belongs_to :category
  has_many :product_images, dependent: :destroy
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :order_products
  has_many :ratings, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates :description, presence: true

  scope :by_name, ->(name){where "products.name LIKE ?", "%#{name}%"}
  scope :ordered_by_name, ->{order(name: :asc)}
  def self.by_price str_price
    case str_price
    when "<1tr"
      where("price < 1000000")
    when ">5tr"
      where("price > 5000000")
    when "1-5tr"
      where("price > 1000000 and price < 5000000")
    end
  end
end
