class User < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :street_address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :email
  validates_presence_of :password, require: true
  validates_presence_of :role

  validates_uniqueness_of :email

  has_many :orders

  belongs_to :merchant, optional: true

  enum role: %w(regular default merchant admin)
  has_secure_password
end
