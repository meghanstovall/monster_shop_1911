class Discount < ApplicationRecord
  validates_presence_of :name, :percent_off, :min_quantity
  belongs_to :merchant
  has_many :item_discounts
  has_many :items, through: :item_discounts
end
