class Notifier < ActionMailer::Base
  default from: "Mandarin Minds <itsupport@mandarinminds.com>"
  
  def welcome(user)
  	@user = user
    mail(to: user.email, 
    	subject: 'Welcome to Mandarin Minds')
  end
  
  def lessonalert(user, lessons)
  	@user = user
  	@lessonstoday = lessons
  	@date = Time.now.in_time_zone("Perth").strftime("#{Time.now.in_time_zone("Perth").day.ordinalize} %B")
    mail(to: user.email, subject: "Lesson Alert for #{@date}")
  end
end
