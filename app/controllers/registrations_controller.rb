class RegistrationsController < Devise::RegistrationsController

  def create
    super
    Notifier.welcome(@user).deliver unless @user.invalid?
    @user.lesson_count = 1 unless @user.invalid?
  end

end