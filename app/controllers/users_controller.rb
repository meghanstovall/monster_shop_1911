class UsersController < ApplicationController

  def new
    @user = User.new(user_params)
  end

  def create
    create_user
  end

  def show
    require_user
    if session[:user_id]
      @user = User.find(session[:user_id])
      flash[:success] = "#{@user.name} is logged in."
    end
  end

  def edit
   @user = User.find(params[:profile_id])
  end

  def update
    update_user
  end

  def edit_password
    @user = User.find(session[:user_id])
  end

  def update_password
    password_update
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

  def create_user
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

  def update_user
    user = User.find(session[:user_id])
    user.update(user_params)
    if user.save
      flash[:sucess] = "Changes Made to Profile Successfully"
      redirect_to '/profile'
    else
      flash[:error] = "#{user.errors.full_messages.to_sentence}"
      redirect_to "/profile/#{user.id}/edit"
    end
  end

  def password_update
    user = User.find(session[:user_id])
    if user.update(user_params)
      flash[:sucess] = "Password Updated Successfully"
      redirect_to '/profile'
    else
      flash[:failure] = "Passwords must match!"
      redirect_to "/profile/#{user.id}/edit_password"
    end
  end
end
