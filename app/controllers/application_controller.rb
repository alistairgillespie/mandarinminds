class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_action :authenticate_user!
  
  def after_sign_in_path_for(resource_or_scope)
  	user_path(@user)
  end
  
  def after_sign_up_path_for(resource)
  	user_path(@user)
  end
  
  before_filter :update_sanitized_params, if: :devise_controller?
  
  def update_sanitized_params
	devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:skypeid, :firstname, :email, :password)}
  end  
end
