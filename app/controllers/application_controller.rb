class ApplicationController < ActionController::Base
  before_action :current_user
  protect_from_forgery with: :exception

  helper_method :cart, :current_user

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    # require "pry"; binding.pry
    return false unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

end
