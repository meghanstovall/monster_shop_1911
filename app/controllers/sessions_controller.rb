class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user != nil && user.authenticate(params[:password])
      login_process(user)
    else
      flash[:notice] = "Login Failed; Your Credentials were Incorrect"
      render :new
    end
  end

  private

  def login_process(user)
    if user.default?
      redirect_to '/profile'
    elsif user.merchant?
      redirect_to '/merchant/dashboard'
    elsif user.admin?
      redirect_to '/admin/dashboard'
    end
    session[:user_id] = user.id
    flash[:success] = "Welcome, #{user.name}!"
  end


end
