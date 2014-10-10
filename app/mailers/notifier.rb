class Notifier < ActionMailer::Base
  default from: "Mandarin Minds <itsupport@mandarinminds.com>"
  
  def welcome(user)
  	@user = user
    mail(to: user.email, 
    	subject: 'Welcome to Mandarin Minds')
  end

  def purchase_summary(purchases)
    @purchases = purchases
    @date = (Time.now.in_time_zone("Perth") - 24.hours).strftime("#{(Time.now.in_time_zone("Perth") - 24.hours).day.ordinalize} %B")
    mail(to: "itsupport@mandarinminds.com", subject: "Purchase Summary for #{@date}") 
  end
  
  def lessonalert(user, lessons)
  	@user = user
  	@lessonstoday = lessons
  	@date = Time.now.in_time_zone("Perth").strftime("#{Time.now.in_time_zone("Perth").day.ordinalize} %B")
    mail(to: user.email, subject: "Lesson Alert for #{@date}")
  end

  def contact_form(name, email, body)
    @name = name
    @email = email
    @body = body
    mail(to: 'itsupport@mandarinminds.com', subject: "Sales Contact Form: New message from '#{name}'")
  end
end
