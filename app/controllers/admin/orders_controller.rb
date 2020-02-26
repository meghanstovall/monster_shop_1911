class Admin::OrdersController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @order = Order.find(params[:order_id])
  end
end
