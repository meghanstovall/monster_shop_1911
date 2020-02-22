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
    elsif params[:quantity] == "add"
      flash[:error] = "Out of Stock"
      redirect_to '/cart'
    elsif params[:quantity] == "subtract" && session[:cart][params[:item_id]] > 1
      session[:cart][params[:item_id]] -= 1
      redirect_to '/cart'
    else params[:quantity] == "subtract" && session[:cart][params[:item_id]] == 1
      flash[:notice] = "Item has been removed from the cart"
      remove_item
    end
  end
  
end
