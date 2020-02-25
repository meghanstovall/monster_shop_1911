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
    update_merch_process(merchant)
  end

  def update_merch_process(merchant)
    update_merch_step_1(merchant) if merchant.disabled == true
    update_merch_step_2(merchant) if merchant.disabled == false
    redirect_to '/admin/merchants'
  end

  def update_merch_step_1(merchant)
    merchant.deactivate_items
    flash[:notice] = "Merchant has been disabled"
  end

  def update_merch_step_2(merchant)
    merchant.activate_items
    flash[:notice] = "Merchant has been enabled"
  end
end
