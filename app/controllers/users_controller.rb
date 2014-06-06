class UsersController < ApplicationController
  layout 'generate'
  before_filter :authenticate_user!

  def index
    @users = User.all.sort_by { |u| u.username.downcase }
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end
end
