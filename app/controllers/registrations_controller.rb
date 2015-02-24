class RegistrationsController < Devise::RegistrationsController

  def create
    super
    unless @user.invalid?
    	Notifier.delay.welcome(@user)
        Notifier.delay.welcome_report(@user)
    	@user.lesson_count = 1
        @user.total_lessons_bought = 0
        @user.save!
    	@settings = UserSettings.new
    	   @settings.user_id = @user.id
    	   @settings.purchased_dudu = false
    	   @settings.receive_morning_emails = true
    	@settings.save!

        @notification_params = {
            :user_id => @user.id,
            :image => '<i class="fa fa-gift"></i>',
            :content => "Welcome to Mandarin Minds, #{@user.firstname}! Please accept this free lesson as a gift to help start you on your adventure here with us",
            :lesson_id => nil,
            :dismissed => false,
            :link => nil
            }
        @n = Notification.new(@notification_params)
        @n.save

        if @user.referred_by 
            @notification_params = {
                :user_id => @user.referred_by,
                :image => '<i class="fa fa-thumbs-o-up"></i>',
                :content => "Your referred friend #{@user.firstname} #{@user.lastname} has just signed up with Mandarin Minds.",
                :lesson_id => nil,
                :dismissed => false,
                :link => nil
                }
            @n = Notification.new(@notification_params)
            @n.save
        end
    end

    

  end

  protected

    def after_update_path_for(resource)
        flash[:notice] = 'Your settings have been updated.'
        user_path(resource)

    end

end