class Discount < ApplicationRecord
  validates_presence_of :name, :percent_off, :min_quantity
  belongs_to :merchant
end
