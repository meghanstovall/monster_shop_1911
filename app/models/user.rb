class User < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :street_address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :email
  validates_presence_of :password, require: true
  # attr_accessor :password_confirmation

  validates_uniqueness_of :email

  has_secure_password
end
