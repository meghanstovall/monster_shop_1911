class AddStatusToItemOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :item_orders, :status, :integer, default: 0
    ItemOrder.all.where(status: nil).update_all(status: 0)
  end
end
