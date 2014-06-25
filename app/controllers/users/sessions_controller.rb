class Users::SessionsController < Devise::SessionsController

  def new
    redirect_to root_url, :notice => "You have been logged out."
  end

  def create
    user = User.authenticate(params[:login], params[:encrypted_password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged in successfully."
    else
      flash.now[:alert] = "Invalid login or password."
      render :action => 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "You have been logged out."
  end
end