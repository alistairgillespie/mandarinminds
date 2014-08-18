class RegistrationsController < Devise::RegistrationsController

  def create
    super
    Notifier.welcome(@user).deliver unless @user.invalid?
  end

end