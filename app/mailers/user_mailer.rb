class UserMailer < ActionMailer::Base
  default from: "itsupport@mandarinminds.com"
  
  def welcome(user)
  	@user = user
    mail(to: user.email, subject: 'Welcome to Mandarin Minds')
  end
end
