class Notifier < ActionMailer::Base
  default from: "Mandarin Minds <itsupport@mandarinminds.com>"
  
  def welcome(user)
  	@user = user
    mail(to: "scott.w.lyle@gmail.com", 
    	subject: 'Welcome to Mandarin Minds')
  end
end
