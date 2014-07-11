class ChargesController < ApplicationController

def new
	@plan = Plan.find(params[:id])
end

def create
  @plan = Plan.find(params[:id])
  
  # Amount in cents
  @amount = @plan.price

  customer = Stripe::Customer.create(
    :email => 'example@stripe.com',
    :card  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @amount,
    :description => 'Rails Stripe customer',
    :currency    => 'aud'
  )

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to '/plans'  
end

end
