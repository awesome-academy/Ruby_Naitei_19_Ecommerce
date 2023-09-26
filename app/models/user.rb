class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :suggestions, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, length: {maximum: Settings.email_length},
format: {with: Settings.VALID_EMAIL_REGEX}, uniqueness: true

  has_secure_password
end