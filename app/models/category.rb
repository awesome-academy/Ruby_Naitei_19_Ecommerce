class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true

  scope :by_name, ->(category){where name: category}
  scope :ordered_by_name, ->{order(name: :asc)}
end
