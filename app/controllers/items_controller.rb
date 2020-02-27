class ItemsController<ApplicationController

  def index
    index_step_1 if params[:merchant_id]
    @items = Item.all if params[:merchant_id] == nil
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    create_items
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    update_items
  end

  def destroy
    destroy_process
    redirect_to "/items"
  end


  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end

  def index_step_1
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
  end

  def destroy_process
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
  end

  def create_items
    @merchant = Merchant.find(params[:merchant_id])
    save_process
  end

  def save_process
    item = @merchant.items.create(item_params)
    redirect_to "/merchants/#{@merchant.id}/items" if item.save == true
    create_save_error(item) if item.save == false
  end

  def create_save_error(item)
    flash[:error] = item.errors.full_messages.to_sentence
    render :new
  end

  def update_items
    @item = Item.find(params[:id])
    update_process(item = @item)
  end

  def update_process(item)
    item.update(item_params)
    redirect_to "/items/#{item.id}" if item.save == true
    update_save_error(item) if item.save == false
  end

  def update_save_error(item)
    flash[:error] = @item.errors.full_messages.to_sentence
    render :edit
  end

end
