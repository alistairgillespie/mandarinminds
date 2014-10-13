Rails.configuration.stripe = {
  #TEST
  #:publishable_key => 'pk_test_jVNGfKeQyOzSyHOyTYcItSYu',
  #:secret_key      => 'sk_test_4HvbPmiiMrrSRhcQh0dhMPiF',
  #LIVE
  :publishable_key => 'pk_live_6SOKGFHuxcL3OweYIqIthLHD',
  :secret_key      => 'sk_live_3Q6TbtTYVgvwmXhoWQlNCQvd',
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.configure do |events|
	events.subscribe 'customer.subscription.deleted', CustomerSubscriptionDeleted.new
	events.subscribe 'invoice.payment_succeeded', InvoicePaymentSucceeded.new	
end
  

