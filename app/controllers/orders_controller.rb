class OrdersController <ApplicationController

  def new
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    user = User.find_by(name: params[:name])
    order = user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      flash[:success] = "Your order has been placed!"
      if user.role == 'regular'
        redirect_to "/orders/#{order.id}"
      else
        redirect_to "/profile/orders"
      end
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def index
    @user = current_user
  end

  def update
    order = current_user.orders.find(params[:id])
    order.update_process
    redirect_to '/profile/orders'
    flash[:notice] = 'Order has been cancelled.'
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
