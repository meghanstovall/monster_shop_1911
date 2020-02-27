class OrdersController < ApplicationController

  def new
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    create_order
  end

  def index
    @user = current_user
  end

  def update
    update_order
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

  def create_order
    user = User.find_by(name: params[:name])
    order = user.orders.create(order_params)
    create_order_process(user, order)
  end

  def create_order_process(user, order)
    save_order(user, order) if order.save == true
    save_order_error if order.save == false
  end

  def save_order(user, order)
    save_order_1(user, order)
    save_order_2(user, order)
    save_order_3(user, order)
  end

  def save_order_1(user, order)
    cart.items.each do |item,quantity|
      order.item_orders.create({item: item, quantity: quantity, price: item.price})
    end
  end

  def save_order_2(user, order)
    session.delete(:cart)
    flash[:success] = "Your order has been placed!"
  end

  def save_order_3(user, order)
    redirect_to "/orders/#{order.id}" if user.role == 'regular'
    redirect_to "/profile/orders" if user.role != 'regular'
  end

  def save_order_error
    flash[:notice] = "Please complete address form to create an order."
    render :new
  end

  def update_order
    current_user.orders.find(params[:id]).cancel_process
    redirect_to '/profile/orders'
    flash[:notice] = 'Order has been cancelled.'
  end
end
