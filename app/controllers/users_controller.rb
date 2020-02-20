class UsersController < ApplicationController

  def new
    @user = User.new(user_params)
  end

  def create
    # @user = User.new(user_params)
    @user = User.create(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "#{@user.name} is now logged in"
      redirect_to '/profile'
    else
      flash[:error] = "#{@user.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def show
    require_user
    if session[:user_id]
      @user = User.find(session[:user_id]) 
      flash[:success] = "#{@user.name} is logged in."
    end
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

    def require_user
      render file: "/public/404" unless current_user
    end
end
