class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    update_item
  end

  def destroy
    item = Item.find(params[:item_id])
    item.destroy
    destroy_flash_and_redirect(item)
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
    item.image = "https://i.picsum.photos/id/866/200/300.jpg" if item.image == '' || item.image == nil
  end

  def activation_process(item)
    item.updates_active
    activation_process_flashes(item)
    redirect_to "/admin/merchants/#{params[:merchant_id]}/items"
  end

  def activation_process_flashes(item)
    flash[:update] = "#{item.name} is no longer for sale." if item.active? == false
    flash[:update] = "#{item.name} is now available for sale." if item.active? == true
  end

  def save_process(item, render_arg, message)
    default_image(item)
    save_process_step_1(message) if item.save == true
    save_process_step_2(item, render_arg) if item.save == false
  end

  def save_process_step_1(message)
    flash[:saved] = message
    redirect_to "/admin/merchants/#{params[:merchant_id]}/items"
  end

  def save_process_step_2(item, render_arg)
    flash[:error] = item.errors.full_messages.to_sentence
    render render_arg
  end

  def update_item
    @item = Item.find(params[:item_id])
    update_item_step_1(item = @item) if params[:commit] == "Update Item"
    activation_process(@item) if params[:commit] != "Update Item"
  end

  def update_item_step_1(item)
    item.update(item_params)
    save_process(item, render_arg = :edit, message = "#{item.name} is updated.")
  end

  def destroy_flash_and_redirect(item)
    flash[:destroy] = "#{item.name} is now deleted."
    redirect_to "/admin/merchants/#{params[:merchant_id]}/items"
  end

end
