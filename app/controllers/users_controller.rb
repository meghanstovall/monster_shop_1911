class UsersController < ApplicationController

  def new
    @user = User.new(user_params)
  end

  def create
    create_user
  end

  def show
    require_user
    show_message if session[:user_id]
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
    params.permit(:name, :street_address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

  def require_user
    render file: "/public/404" unless current_user
  end

  def create_user
    @user = User.create(user_params)
    create_save_process(user = @user) if @user.save == true
    create_save_error(user = @user) if @user.save == false
  end

  def create_save_process(user)
    session[:user_id] = user.id
    flash[:notice] = "#{user.name} is now logged in"
    redirect_to '/profile'
  end

  def create_save_error(user)
    flash[:error] = "#{user.errors.full_messages.to_sentence}"
    render :new
  end

  def update_user
    user = User.find(session[:user_id])
    user.update(user_params)
    update_redirects(user)
  end

  def update_redirects(user)
    redirects_1(user) if user.save == true
    redirects_2(user) if user.save == false
  end

  def redirects_1(user)
    flash[:sucess] = "Changes Made to Profile Successfully"
    redirect_to '/profile'
  end

  def redirects_2(user)
    flash[:error] = "#{user.errors.full_messages.to_sentence}"
    redirect_to "/profile/#{user.id}/edit"
  end

  def create_save_process(user)
    session[:user_id] = user.id
    flash[:notice] = "#{user.name} is now logged in"
    redirect_to '/profile'
  end

  def create_save_error(user)
    flash[:error] = "#{user.errors.full_messages.to_sentence}"
    render :new
  end

  def password_update
    user = User.find(session[:user_id])
    password_1 if user.update(user_params)
    password_2(user) if user.update(user_params) == false
  end

  def password_1
    flash[:sucess] = "Password Updated Successfully"
    redirect_to '/profile'
  end

  def password_2(user)
    flash[:failure] = "Passwords must match!"
    redirect_to "/profile/#{user.id}/edit_password"
  end

  def show_message
    @user = User.find(session[:user_id])
    flash[:success] = "#{@user.name} is logged in."
  end

end
