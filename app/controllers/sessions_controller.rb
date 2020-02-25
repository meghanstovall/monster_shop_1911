class SessionsController < ApplicationController
  def new
    new_user_id
  end

  def create
    user = User.find_by(email: params[:email])
    create_session(user)
  end

  def destroy
    destroy_process
    redirect_to "/"
  end



  private

  def destroy_process
    session.delete(:user_id)
    session.delete(:cart)
    flash[:success] = "You have successfully logged out."
  end

  def login_process(user)
    login_process_redirects(user)
    session[:user_id] = user.id
    flash[:success] = "Welcome, #{user.name}!"
  end

  def login_process_redirects(user)
    redirect_to '/profile' if user.default?
    redirect_to '/merchant/dashboard' if user.merchant?
    redirect_to '/admin/dashboard' if user.admin?
  end

  def new_user_id
    if new_user = User.find_by(id: session[:user_id])
      new_user_redirects(new_user)
    end
  end

  def new_user_redirects(new_user)
    admin_redirect(new_user) if new_user.admin?
    merchant_redirect(new_user) if new_user.merchant?
    default_redirect(new_user) if new_user.default?
  end

  def admin_redirect(new_user)
    redirect_to "/admin/dashboard"
    flash[:notice] = "Already logged in as #{new_user.name}"
  end

  def merchant_redirect(new_user)
    redirect_to "/merchant/dashboard"
    flash[:notice] = "Already logged in as #{new_user.name}"
  end

  def default_redirect(new_user)
    redirect_to "/profile"
    flash[:notice] = "Already logged in as #{new_user.name}"
  end

  def create_session(user)
    if user != nil && user.authenticate(params[:password])
      login_process(user)
    else
      create_session_error
    end
  end

  def create_session_error
    flash[:notice] = "Login Failed; Your Credentials were Incorrect"
    render :new
  end
end
