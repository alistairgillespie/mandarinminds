class ChargesController < ApplicationController

def new
	@plan = Plan.find(params[:id])
end

def index
  if user_signed_in?
    @mycharges = Charge.where("user_id = ?", current_user.id).order("created_at")
  else
    redirect_to "/sign_in", notice: "You must be signed in to see that page"
  end
end


def create
  @plan = Plan.find(params[:id])
  @user = current_user

  begin
    customer = Stripe::Customer.create(
      :email => @user.email,
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @plan.price * 100, #amount in cents
      :description => 'Rails Stripe customer',
      :currency    => 'aud'
    )
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to '/plans'  
  end

  @charge_params = {
            :user_id => @user.id,
            :description => @plan.name,
            :amount => @plan.price * 100 #amount in cents
            }
  @c = Charge.new(@charge_params)
  @c.save

  ######Send email invoice to user

  if @plan.name == "Dudu Package"
    current_user.settings.purchased_dudu = true
    current_user.settings.save
    flash[:notice] = "Your Dudu purchase has been successful. You can now access your Dudu resources from the Dashboard."
  else
    current_user.lesson_count = current_user.lesson_count + @plan.lessons
    current_user.save
    flash[:notice] = "Your purchased has been processed successfully and your number of lessons to spend has increased by #{@plan.lessons}. Current lesson total: #{current_user.lesson_count}."
  end

  redirect_to current_user
end
end

