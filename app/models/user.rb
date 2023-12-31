class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :suggestions, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, length: {maximum: Settings.email_length},
format: {with: Settings.email_regex}, uniqueness: true

  has_secure_password

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost:
  end
end
