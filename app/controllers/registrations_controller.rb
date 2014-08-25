class RegistrationsController < Devise::RegistrationsController

  def create
    super
    unless @user.invalid?
    	Notifier.welcome(@user).deliver 
    	@user.lesson_count = 1
    	@settings = UserSettings.new
    	@settings.user_id = @user.user_id
    	@settings.purchased_dudu = false
    	@settings.receive_morning_emails = true
    	@settings.save!
    end

    

  end

  protected

    def after_update_path_for(resource)
      user_path(resource)
    end

end