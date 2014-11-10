class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource_or_scope)
  	user_path(@user)
  end
  
  def after_sign_up_path_for(resource)
  	user_path(@user)
  end
  
  before_filter :update_sanitized_params, if: :devise_controller?
  before_filter :get_next_lesson
  
  def update_sanitized_params
	devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:skypeid, :firstname, :lastname, :email, :password)}
  end  

  def get_next_lesson
    @nextlesson = nil
    if user_signed_in?
      if current_user.role_id == 1 #student
        @nextlesson = Lesson.where("student_id = ? AND starts_at > ? AND teacher_id IS NOT NULL", current_user.id, Time.now.utc - 15.minutes).order(starts_at: :asc).first
      elsif current_user.role_id == 2 #teacher
        @nextlesson = Lesson.where("teacher_id = ? AND starts_at > ? AND student_id IS NOT NULL", current_user.id, Time.now.utc - 15.minutes).order(starts_at: :asc).first
      end
    end
  end

  

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :skypeid
    devise_parameter_sanitizer.for(:account_update) << :skypeid
    devise_parameter_sanitizer.for(:account_update) << :firstname
    devise_parameter_sanitizer.for(:account_update) << :lastname
    devise_parameter_sanitizer.for(:account_update) << :timezone_offset
  end
  

end
