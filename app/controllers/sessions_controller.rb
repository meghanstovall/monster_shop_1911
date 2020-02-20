class SessionsController < ApplicationController
  def new
    new_user_id
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

  def destroy
    session.delete(:user_id)
    session.delete(:cart)
    flash[:success] = "You have successfully logged out."
    redirect_to "/"
  end

  private

  def login_process(user)
    if user.default?
      # require "pry"; binding.pry
      redirect_to '/profile'
    elsif user.merchant?
      redirect_to '/merchant/dashboard'
    elsif user.admin?
      redirect_to '/admin/dashboard'
    end
    session[:user_id] = user.id
    flash[:success] = "Welcome, #{user.name}!"
  end

def new_user_id
  if new_user = User.find_by(id: session[:user_id])
    if new_user.admin?
        redirect_to "/admin/dashboard"
        flash[:notice] = "Already logged in as #{new_user.name}"
      elsif new_user.merchant?
        redirect_to "/merchant/dashboard"
        flash[:notice] = "Already logged in as #{new_user.name}"
      elsif new_user.default?
        redirect_to "/profile"
        flash[:notice] = "Already logged in as #{new_user.name}"
      end
    end
  end
end
