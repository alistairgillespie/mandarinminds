class ChargesController < ApplicationController

def new
	@plan = Plan.find(params[:id])
end

def index
  if user_signed_in?
    @mycharges = Charge.where("user_id = ? AND status = ?", current_user.id, "Completed").order("created_at")
  else
    redirect_to "/sign_in", notice: "You must be signed in to see that page"
  end
end


def create
  @plan = Plan.find(params[:id])
  @user = current_user

  if @plan.name == "eBooks Package Subscription"

    begin

      customer = Stripe::Customer.create(
        :card => params[:stripeToken],
        :email => @user.email
      )

      subscription = customer.subscriptions.create(:plan => "dudu", :prorate => false)
      
     rescue Stripe::CardError => e
      @c.status = "Error"
      @c.save!
      flash[:error] = e.message
      redirect_to '/plans'  
      return
    end

    @user.update_attribute(:stripe_id, customer.id)
    #dont show - invoice handler will deal with it @user.settings.update_attribute(:dudu_expiry_timestamp, subscription.current_period_end)
    @user.settings.update_attribute(:purchased_dudu, true)
    
    @notification_params = {
            :user_id => @user.id,
            :image => '<i class="fa fa-money"></i>',
            :content => "Your Dudu subscription has been successful. You will be notified when you payment has been processed (usually less than a minute) after which you can access the package from your Dashboard.",
            :lesson_id => nil,
            :dismissed => false,
            :link => '/dashboard'
            }
    @n = Notification.new(@notification_params)
    @n.save

    redirect_to current_user, notice: "Your subscription to Dudu has been successful. You will be notified (usually in less than a minute) when your payment has been approved."
    Pusher.trigger("private-#{@notification_params[:user_id]}",'notification', {"image" => @notification_params[:image],
            "message" => @notification_params[:content],
            })
  else ### REGULAR LESSON PURCHASE

    begin
      @charge_params = {
              :user_id => @user.id,
              :description => @plan.name,
              :amount => @plan.price * 100, #amount in cents
              :status => "Pending"
              }
      @c = Charge.new(@charge_params)
      @c.save

      charge = Stripe::Charge.create(
        #:customer    => customer.id,
        :card  => params[:stripeToken],
        :amount      => @plan.price * 100, #amount in cents
        :description => "MM Customer: #{@plan.name}",
        :currency    => 'aud'
      )

      @c.status = "Processing"
      @c.stripe_id = charge.id
      @c.save!

      if current_user.lesson_count.nil?
        @current_user.update_attribute(:lesson_count, 0)
      end
      current_user.lesson_count = current_user.lesson_count + @plan.lessons
      
      if current_user.total_lessons_bought.nil?
        @current_user.update_attribute(:total_lessons_bought, 0)
      end
      current_user.total_lessons_bought = current_user.total_lessons_bought + @plan.lessons
      current_user.save
      @notification_params = {
              :user_id => @user.id,
              :image => '<i class="fa fa-plus"></i>',
              :content => "Your purchased has been processed successfully and your number of lessons to spend has increased by #{@plan.lessons}",
              :lesson_id => nil,
              :dismissed => false,
              :link => nil
              }
      @n = Notification.new(@notification_params)
      @n.save

      if current_user.total_lessons_bought >= 10 && current_user.total_lessons_bought - @plan.lessons < 10 && current_user.referred_by
        @referrer = User.find(current_user.referred_by)
        @notification_params = {
              :user_id => @referrer.id,
              :image => '<i class="fa fa-gift"></i>',
              :content => "Your referred student #{@user.firstname} #{@user.lastname} has just bought enough lessons to grant you a bonus 5 lessons! Your new lesson total is #{@referrer.lesson_count + 5}",
              :lesson_id => nil,
              :dismissed => false,
              :link => nil
              }
        @n = Notification.new(@notification_params)
        @n.save
        @referrer.update_attribute(:lesson_count, @referrer.lesson_count + 5)
      end



    rescue Stripe::CardError => e
      @c.status = "Error"
      @c.save!
      flash[:error] = e.message
      redirect_to '/plans'  
      return
    end

    @c.status = "Completed"
    @c.save!

    redirect_to current_user
  end
 
  end
end




