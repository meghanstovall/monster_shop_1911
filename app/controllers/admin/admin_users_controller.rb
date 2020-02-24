class Admin::AdminUsersController < Admin::BaseController
  def index
    @users = User.all
  end
end
