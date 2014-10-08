class StripeEventsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :parse_and_validate_event

  def create
    puts "***LOG*** Starting  create"
    if self.class.private_method_defined? event_method
      puts "***LOG*** method is defined"
      self.send(event_method, @event.event_object)
    end
    puts "***LOG*** Method not defined or event handling finished"
    render nothing: true
  end

  private

  def event_method
    "stripe_#{@event.stripe_type.gsub('.', '_')}".to_sym
  end

  def parse_and_validate_event
    puts "***LOG*** Starting parsing"
    @event = StripeEvent.new(stripe_id: params[:id], stripe_type: params[:type])
    puts "***LOG*** Event created"
    Pusher.trigger("private-1",'notification', {"image" => "",
              "message" => "New event #{@event.inspect}",
              })
    puts "***LOG*** Pusher"
    unless @event.save
      if @event.valid?
        puts "***LOG*** No save, valid"
        render nothing: true, status: 400 # valid event, try again later
      else
        puts "***LOG*** No save, invalid"
        render nothing: true # invalid event, move along
      end
    end 
    puts "***LOG*** Event saved!"
  end

  def stripe_charge_dispute_created(event)
    StripeMailer.admin_dispute_created(event).deliver
  end

  def invoice_payment_succeeded(event)
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

  end



end