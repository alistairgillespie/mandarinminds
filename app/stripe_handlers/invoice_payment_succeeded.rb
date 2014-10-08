class InvoicePaymentSucceeded
	def call(event)
		dbevent = StripeWebhook.new(stripe_id: event.id, stripe_type: event.type)
		unless dbevent.save
			if dbevent.valid?
				render nothing: true, status: 400 # valid event, try again later
			else
				render nothing: true # invalid event, move along
			end
		else		
		    @user = User.find_by stripe_id: event.data.object.customer
		    if @user
			    @subscription = Stripe::Customer.retrieve(@user.stripe_id).subscriptions.first
			    @user.settings.update_attribute(:dudu_expiry_timestamp, @subscription.current_period_end)

			    @charge_params = {
		            :user_id => @user.id,
		            :description => "Dudu Monthly Subscription",
		            :amount => event.data.object.lines.data.first.plan.amount, #amount in cents
		            :status => "Completed"
		        }
		        @c = Charge.new(@charge_params)
		        @c.save

			    @notification_params = {
			                  :user_id => @user.id,
			                  :image => '<i class="fa fa-money"></i>',
			                  :content => "Your latest invoice payment has been paid successfully and your Dudu subscription has been extended to #{Time.at(@user.settings.dudu_expiry_timestamp).strftime('%-d %B %Y')}. Check your Charges Page to see more.",
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
		end
	end
end