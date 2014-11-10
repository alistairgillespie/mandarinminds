class StaticController < ApplicationController
  # Create a def for each static page, then add it to routes
  # and add the .html.erb to the app/views/static folder

  def index
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
    Notifier.contact_form(params[:name], params[:email], params[:body]).deliver
    redirect_to '/plans', notice: "Your message has been sent successfully!"
  end
end
