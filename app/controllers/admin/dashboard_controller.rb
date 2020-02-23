class Admin::DashboardController < Admin::BaseController

  def show
    @orders = Order.all
  end

  def update
    order = Order.find(params[:id])
    order.ship_and_fulfill
    redirect_to "/admin/dashboard"
  end
end
