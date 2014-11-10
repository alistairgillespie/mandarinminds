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
	    mail(to: 'itsupport@mandarinminds.com', subject: 'AUTO: Charge Succeeded!')
	end

  	#def receipt(charge)
	#    @charge = charge
	#    @sale = Sale.find_by!(stripe_id: @charge.id)
	#    mail(to: @sale.email, subject: "Thanks for purchasing #{@sale.product.name}")
	#end
end