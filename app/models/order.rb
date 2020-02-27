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
    item_orders.update(status: 0)

    item_orders.each do |item_order|
      item_order.item.update(inventory: (item_order.item.inventory + item_order.quantity))
    end
  end

  def fulfill
    item_orders.update(status: 1)
    update(status: 2)
  end

  def ship_and_fulfill
    item_orders.update(status: 1)
    update(status: 3)
  end

  def merchant_quantity(merchant_id)
    item_orders.joins(:item).where(items: {merchant_id: merchant_id}).sum(:quantity)
  end

  def merchant_total(merchant_id)
    item_orders.joins(:item).where(items: {merchant_id: merchant_id}).sum('item_orders.price * item_orders.quantity')
  end
end
