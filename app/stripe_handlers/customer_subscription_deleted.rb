class CustomerSubscriptionDeleted
	def call(event)
		if event.livemode
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
					@user.settings.update_attribute(:purchased_dudu, false)
					@notification_params = {
			              :user_id => @user.id,
			              :image => '<i class="fa fa-money"></i>',
			              :content => "The cancellation of your Dudu Subscription has been successful. You will still have access for the rest of the period which ends on #{Time.at(@user.settings.dudu_expiry_timestamp).strftime('%-d %B %Y')}.",
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
end