class UsersController < ApplicationController
  layout 'generate'
  before_filter :authenticate_user!
      
  def index
    @users = User.all.sort_by{|u| u.username.downcase}
  end
end
