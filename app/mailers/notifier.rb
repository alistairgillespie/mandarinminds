class Notifier < ActionMailer::Base
  default from: "Mandarin Minds <itsupport@mandarinminds.com>"
  
  def welcome(user)
  	@user = user
    mail(to: user.email, 
    	subject: 'Welcome to Mandarin Minds')
  end
  
  def lessonalert(user)
  	@user = user
  	@lessonstoday = user.lessons_to_attend.where('starts_at BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day)
  	if (@lessonstoday.size > 0)
  		mail(to: user.email, subject: "Lesson Alert for #{Time.now.strftime('%B %-d')}")
	end
  end
end
