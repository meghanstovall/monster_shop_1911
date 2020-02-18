class UsersController < ApplicationController
  def new
    @user = User.new(user_params)
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
