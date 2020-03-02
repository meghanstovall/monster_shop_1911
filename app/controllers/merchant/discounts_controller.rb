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
    if @discount.save
      redirect_to "/merchant/discounts"
    else
      flash[:notice] = @discount.errors.full_messages.to_sentence
      render :edit
    end
  end


  private
    def discount_params
      params.permit(:name, :percent_off, :min_quantity)
    end
end
