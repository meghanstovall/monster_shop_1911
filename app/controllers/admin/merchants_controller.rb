class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.enable_disable
    if merchant.disabled
      merchant.deactivate_items
    end
    flash[:notice] = "Merchant has been disabled"

    redirect_to '/admin/merchants'
  end
end
