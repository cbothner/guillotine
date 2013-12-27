class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  protect_from_forgery

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :email
  end
  def user_is_dd?
    current_user == User.where("username = 'dd'")
  end
end
