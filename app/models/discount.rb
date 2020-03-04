class Discount < ApplicationRecord
  validates :name, presence: true
  validates :percent_off, presence: true, numericality: { less_than_or_equal_to: 100 }
  validates :min_quantity, presence: true, numericality: { more_than: 0 }

  belongs_to :merchant
  has_many :item_discounts, dependent: :destroy
  has_many :items, through: :item_discounts
end
