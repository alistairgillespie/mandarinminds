class StripeWebhook < ActiveRecord::Base
	validates_uniqueness_of :stripe_id

  	def event_object
  		begin
  		puts "***LOG*** Looking up event"
	    event = Stripe::Event.retrieve(stripe_id)
	    puts "***LOG*** sending out event object"
	    return event.data.object

		rescue Stripe::InvalidRequestError => e
			puts "Error: #{e.message}"
			return nil
		end
	end 

	def stripe_charge_dispute_created(event)

    #StripeMailer.admin_dispute_created(event).deliver
    puts "***LOG*** dispute created"
  end

  def stripe_invoice_payment_succeeded(event)
=begin
    StripeMailer.admin_charge_succeeded(event).deliver
    @charge = Charge.find_by(stripe_id: event.id)
    if @charge
      @user = User.find_by(id: @charge.user_id)
      @subscription = Stripe::Customer.retrieve(@user.stripe_id).subscriptions.first
      @user.settings.update_attribute(:dudu_expiry_timestamp, @subscription.current_period_end)
      @notification_params = {
                  :user_id => @user.id,
                  :image => '<i class="fa fa-money"></i>',
                  :content => "Your latest invoice payment has been paid successfully and your Dudu subscription has been extended to #{Time.at(@user.settings.dudu_expiry_timestamp).strftime('%-d %B %Y')}. Check your Charges Page to see more."
                  :link => "/charges",
                  :lesson_id => nil,
                  :dismissed => false
      }
      @n = Notification.new(@notification_params)
      @n.save
      Pusher.trigger("private-#{@notification_params[:user_id]}",'notification', {"image" => @notification_params[:image],
        "message" => @notification_params[:content],
      })
    end 
=end
    puts "***LOG*** invoice payment succeeded"
  end

  def stripe_customer_subscription_deleted(event)
  	
  end

	
end
