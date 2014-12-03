class Notifier < ActionMailer::Base
  default from: "Mandarin Minds <itsupport@mandarinminds.com>"
  
  def welcome(user)
  	@user = user
    mail(to: user.email, 
    	subject: 'Welcome to Mandarin Minds')
  end

  def welcome_report(user)
    @user = user
    mail(to: 'sales@mandarinminds.com, itsupport@mandarinminds.com, admin@mandarinminds.com',
      subject: "AUTO: New User '#{user.firstname} #{user.lastname}'")
  end

  def purchase_summary(purchases)
    @purchases = purchases
    @date = (Time.now.in_time_zone("Perth") - 24.hours).strftime("#{(Time.now.in_time_zone("Perth") - 24.hours).day.ordinalize} %B")
    mail(to: "itsupport@mandarinminds.com", subject: "Purchase Summary for #{@date}") 
  end
  
  def lessonalert(user, lessons)
  	@user = User.find_by_id(user)
    if @user.settings.receive_morning_emails
    	@lessonstoday = lessons
    	@date = Time.now.in_time_zone("Perth").strftime("#{Time.now.in_time_zone("Perth").day.ordinalize} %B")
      mail(to: @user.email, subject: "Lesson Alert for #{@date}")
    end
  end

  def contact_form(name, email, body, type)
    @name = name
    @email = email
    @body = body
    if type == 'sales'
      mail(to: 'sales@mandarinminds.com', subject: "Sales Contact Form: New message from '#{name}'")
    else
      mail(to: 'itsupport@mandarinminds.com', subject: "Contact Form: New message from '#{name}'")
    end
  end

  def manager_lesson_alert(lesson_hash)
    @date = Time.now.in_time_zone("Perth").strftime("#{Time.now.in_time_zone("Perth").day.ordinalize} %B")
    @lesson_hash = lesson_hash
    mail(to: 'rstrade@qbs-china.com', subject: "Mandarin Minds Lesson Alert for #{@date}")
  end

  def teacher_lesson_alert(teacher_id, lessons)
    @user = User.find_by_id(teacher_id)
    @date = Time.now.in_time_zone("Perth").strftime("#{Time.now.in_time_zone("Perth").day.ordinalize} %B")
    @lessonstoday = lessons
    mail(to: @user.email, subject: "Lesson Alert for #{@date}")
  end

  def weekly_student_update(students)
    @students = students
    @date = Time.now.in_time_zone("Perth").strftime("#{Time.now.in_time_zone("Perth").day.ordinalize} %B")
    mail(to: 'scott.w.lyle@gmail.com', subject: "Weekly Student Review for #{@date}")
  end
end
