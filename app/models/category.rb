class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :category_name, presence: true

  scope :by_name, ->(category){where category_name: category}
  scope :ordered_by_name, ->{order(category_name: :asc)}
end
