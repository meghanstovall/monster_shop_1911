class CartController < ApplicationController
  before_action :require_not_admin

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def edit_quantity
    adjust_quantity
  end

  private

  def require_not_admin
      render file: "/public/404" if current_admin
  end

  def item
    @item = Item.find(params[:item_id])
  end

  def adjust_quantity
    if params[:quantity] == "add" && item.inventory > session[:cart][params[:item_id]]
      session[:cart][params[:item_id]] += 1
      redirect_to '/cart'
    else params[:quantity] == "add"
      flash[:error] = "Out of Stock"
      redirect_to '/cart'
    end
  end

  # def increment_decrement
  #   if params[:increment_decrement] == "increment"
  #     cart.add_quantity(params[:item_id]) unless cart.limit_reached?(params[:item_id])
  #   elsif params[:increment_decrement] == "decrement"
  #     cart.subtract_quantity(params[:item_id])
  #     return remove_item if cart.quantity_zero?(params[:item_id])
  #   end
  #   redirect_to "/cart"
  # end
end
