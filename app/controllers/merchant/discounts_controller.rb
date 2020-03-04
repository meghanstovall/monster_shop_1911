class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def show
    @discount = Discount.find(params[:discount_id])
  end

  def edit
    @discount = Discount.find(params[:discount_id])
  end

  def update
    @discount = Discount.find(params[:discount_id])
    @discount.update(discount_params)
    if !@discount.save || @discount.percent_off > 100
      flash[:notice] = @discount.errors.full_messages.to_sentence
      render :edit
    else
      flash[:notice] = "Discount has been updated!"
      redirect_to "/merchant/discounts"
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.discounts.create(discount_params)
    if params[:discount_items] == nil || !discount.save || discount.percent_off > 100
      flash[:notice] = "Form not submitted: Required information missing."
      render :new
    else
      items = Item.find(params[:discount_items])
      discount.items << items

      flash[:notice] = "Discount created successfully!"
      redirect_to "/merchant/discounts"
    end
  end

  def destroy
    Discount.destroy(params[:discount_id])
    redirect_to "/merchant/discounts"
  end


  private
    def discount_params
      params.permit(:name, :percent_off, :min_quantity)
    end
end
