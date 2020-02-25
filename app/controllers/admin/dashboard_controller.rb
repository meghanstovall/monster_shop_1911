class Admin::DashboardController < Admin::BaseController

  def show
    @orders = Order.all
  end

  def update
    Order.find(params[:id]).ship_and_fulfill
    redirect_to "/admin/dashboard"
  end
end
