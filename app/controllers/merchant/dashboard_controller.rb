class Merchant::DashboardController < Merchant::BaseController
  def show
    require "pry"; binding.pry
    merchant = Merchant.find(current_user.merchant.id)
    @orders = merchant.orders.all.distinct
  end
end
