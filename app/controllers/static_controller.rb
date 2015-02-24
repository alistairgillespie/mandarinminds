class StaticController < ApplicationController
  # Create a def for each static page, then add it to routes
  # and add the .html.erb to the app/views/static folder

  def index
    if user_signed_in?
      redirect_to '/dashboard'
    end
  end

  def about
  end
  
  def help
  end
  
  def pricing
  end
  
  def chatroom
  end
  
  def terms
  end

  def privacy
  end

  def contact
  end

  def faq
  end

  def features
  end

  def contact_form
    Notifier.delay.contact_form(params[:name], params[:email], params[:body], params[:form_type])
    redirect_to request.referrer, notice: "Your message has been sent successfully!"
  end

  def translation
  end
end
