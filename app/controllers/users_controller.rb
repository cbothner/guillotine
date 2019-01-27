class UsersController < ApplicationController
  layout 'generate'
  before_filter :authenticate_user!

  def index
    @users = User.all.sort_by { |u| u.username.downcase }

    @dd_name = Setting.find_by_key('dd_name')
    @dd_phone = Setting.find_by_key('dd_phone')
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to new_user_path, notice: 'User created successfully'
    else
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end
end
