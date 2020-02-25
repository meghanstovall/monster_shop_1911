class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @item = Item.find(params[:item_id])
    if params[:commit] == "Update Item"
      @item.update(item_params)
      save_process(@item, render_arg = :edit, message = "#{@item.name} is updated.")
    else
      activation_process(@item)
    end
  end

  def destroy
    item = Item.find(params[:item_id])
    item.destroy
    flash[:destroy] = "#{item.name} is now deleted."
    redirect_to "/admin/merchants/#{params[:merchant_id]}/items"
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    item = @merchant.items.create(item_params)
    save_process(item, render_arg = :new, message = "#{item.name} is saved.")
  end

  def edit
    @item = Item.find(params[:item_id])
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end

  def default_image(item)
    if item.image == '' || item.image == nil
      item.image = "https://i.picsum.photos/id/866/200/300.jpg"
    end
  end

  def activation_process(item)
    item.updates_active
    if item.active? == false
      flash[:update] = "#{item.name} is no longer for sale."
    else
      flash[:update] = "#{item.name} is now available for sale."
    end
    redirect_to "/admin/merchants/#{params[:merchant_id]}/items"
  end

  def save_process(item, render_arg, message)
    default_image(item)
    if item.save
      flash[:saved] = message
      redirect_to "/admin/merchants/#{params[:merchant_id]}/items"
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render render_arg
    end
  end

end
