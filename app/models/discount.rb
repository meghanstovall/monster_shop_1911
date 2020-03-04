class Discount < ApplicationRecord
  validates_presence_of :name, :percent_off, :min_quantity
  validates_presence_of :percent_off, less_than_or_equal_to: 100
  belongs_to :merchant
  has_many :item_discounts, dependent: :destroy
  has_many :items, through: :item_discounts
end
