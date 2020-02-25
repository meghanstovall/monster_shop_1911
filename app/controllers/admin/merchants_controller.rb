class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def update
    update_merch
  end



  private

  def update_merch
    merchant = Merchant.find(params[:id])
    merchant.enable_disable
    if merchant.disabled
      merchant.deactivate_items
      flash[:notice] = "Merchant has been disabled"
    else
      merchant.activate_items
      flash[:notice] = "Merchant has been enabled"
    end
    redirect_to '/admin/merchants'
  end
end
