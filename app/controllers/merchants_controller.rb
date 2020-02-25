class MerchantsController <ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    merchant
  end

  def new
  end

  def create
    create_merchant
  end

  def edit
    merchant
  end

  def update
    update_merchant
  end

  def destroy
    Merchant.destroy(params[:id])
    redirect_to '/merchants'
  end




  private

  def merchant_params
    params.permit(:name,:address,:city,:state,:zip)
  end

  def create_merchant
    merchant = Merchant.create(merchant_params)
    redirect_to merchants_path if merchant.save == true
    create_merchant_save_error(merchant) if merchant.save == false
  end

  def create_merchant_save_error(merchant)
    flash[:error] = merchant.errors.full_messages.to_sentence
    render :new
  end

  def update_merchant
    @merchant = Merchant.find(params[:id])
    update_merchant_process(merchant = @merchant)
  end

  def update_merchant_process(merchant)
    merchant.update(merchant_params)
    redirect_to "/merchants/#{merchant.id}" if merchant.save == true
    update_merchant_save_error(merchant) if merchant.save == false
  end

  def update_merchant_save_error(merchant)
    flash[:error] = merchant.errors.full_messages.to_sentence
    render :edit
  end

  def merchant
    @merchant = Merchant.find(params[:id])
  end
end
