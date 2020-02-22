class AddStatusToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :status, :string, default: 'pending'
    Order.all.where(status: nil).update_all(status: 'pending')
  end
end
