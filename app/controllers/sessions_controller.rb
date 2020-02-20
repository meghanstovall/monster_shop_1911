class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    # require "pry"; binding.pry
    if user != nil && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
    end
    if user.merchant?
      redirect_to '/merchant/dashboard'
    end
  end
end
