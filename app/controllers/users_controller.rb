class UsersController < ApplicationController

  def new
    @user = User.new(user_params)
  end

  def create
    # @user = User.new(user_params)
    @user = User.create(user_params)
    if @user.save
      flash[:notice] = "#{@user.name} is now logged in"
      redirect_to '/profile'
    else
      flash[:error] = "#{@user.errors.full_messages.to_sentence}"
      render :new
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
