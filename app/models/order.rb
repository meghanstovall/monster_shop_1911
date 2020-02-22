class Order < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders
  before_save :default_values

  def default_values
    self.status = 'pending'
  end

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_item_quantity
    item_orders.sum('quantity')
  end
end
