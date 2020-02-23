class Order < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders
  enum status: %w(pending cancelled)

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_item_quantity
    item_orders.sum('quantity')
  end

  def update_process
    write_attribute(:status, 1)
    item_orders.each do |item_order|
      item_order.write_attribute(:status, 1)
      item_order.item.write_attribute(:inventory, (item_order.item.inventory + item_order.quantity))
    end
  end
end
