class Lesson < ActiveRecord::Base
	extend SimpleCalendar
  	has_calendar
	belongs_to :student, :class_name => 'User', inverse_of: :lessons_to_attend
	belongs_to :teacher, :class_name => 'User', inverse_of: :lessons_to_teach
	has_many :notifications

	validates_uniqueness_of :teacher_id, :scope => [:starts_at]
	validates_uniqueness_of :student_id, :scope => [:starts_at]

	def self.lessonalert
  		User.where("role_id = 1").each do |u|
  			if u.settings.receive_morning_emails
  				@lessonalerttoday = u.lessons_to_attend.where('starts_at BETWEEN ? AND ?', (Time.now.utc + u.timezone_offset.hours).beginning_of_day, (Time.now.utc + u.timezone_offset.hours).beginning_of_day)
	  			if (@lessonalerttoday.size > 0)
	  				Notifier.lessonalert(u, @lessonalerttoday).deliver
	  			end
  			end
  		end  	
  	end
end
