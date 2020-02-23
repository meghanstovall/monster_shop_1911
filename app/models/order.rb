class Order < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders
  enum status: %w(pending cancelled packaged shipped)

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_item_quantity
    item_orders.sum('quantity')
  end

  def cancel_process
    update(status: 1)
    item_orders.each do |item_order|
      item_order.update(status: 0)
      item_order.item.update(inventory: (item_order.item.inventory + item_order.quantity))
    end
  end

  def fulfill
    item_orders.each do |item_order|
      item_order.update(status: 1)
    end
    update(status: 2)
  end

  def ship_and_fulfill
    item_orders.each do |item_order|
      item_order.update(status: 1)
    end
    update(status: 3)
  end
end
