class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user != nil && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
    end

    if user.default?
      redirect_to '/profile'
      flash[:success] = "#{user.name} is logged in!"
    elsif user.merchant?
      redirect_to '/merchant/dashboard'
      flash[:success] = "#{user.name} is logged in!"
    elsif user.admin?
      redirect_to '/admin/dashboard'
      flash[:success] = "#{user.name} is logged in!"
    end
  end

end
