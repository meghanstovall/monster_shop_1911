class UsersController < ApplicationController

  def new
  end

  def create
    user = User.create(user_params)
    if user.valid?
      flash[:notice] = "#{user.name} is now logged in"
      redirect_to '/profile'
    end
  end

  def show
    
  end

  private

  def user_params
    params.permit(
      :name,
      :street_address,
      :city,
      :state,
      :zip,
      :email,
      :password,
      :password_confirmation)
  end
end
