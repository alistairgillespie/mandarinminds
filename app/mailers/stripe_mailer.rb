class StripeMailer < ActionMailer::Base
	default from: 'itsupport@mandarinminds.com'

	def admin_dispute_created(event)
		@event = event
		@charge = Charge.find_by(stripe_id: @event.id)

		if @charge
			mail(to: 'itsupport@mandarinminds.com', subject: "AUTO: Dispute created on charge #{@charge.guid} (#{event.id})")
		end 
	end

	def admin_charge_succeeded(event)
	    @event = event
	    @charge = Charge.find_by(stripe_id: @event.id)
	    mail(to: 'sales@mandarinminds.com, itsupport@mandarinminds.com, admin@mandarinminds.com', subject: 'AUTO: Charge Succeeded!')
	end
	
end