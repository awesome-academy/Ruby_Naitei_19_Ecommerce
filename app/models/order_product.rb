class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  scope :by_product_id, ->(id){where product_id: id}
end
