class Lesson < ActiveRecord::Base
	extend SimpleCalendar
  	has_calendar
	belongs_to :student, :class_name => 'User', inverse_of: :lessons_to_attend
	belongs_to :teacher, :class_name => 'User', inverse_of: :lessons_to_teach
	has_many :notifications

	validates_uniqueness_of :teacher_id, :scope => [:starts_at]
	validates_uniqueness_of :student_id, :scope => [:starts_at]

	#validates :starts_at, :uniqueness => {scope: :teacher_id, message: 'You cannot teach two lessons at the same time'}
	#validates :starts_at, :uniqueness => {scope: :student_id, message: 'You cannot book two lessons at the same time'}
	
	def self.lessonalert
  		User.where("role_id = 1").each do |u|
  			if u.settings.receive_morning_emails
  				@lessonalerttoday = u.lessons_to_attend.where('starts_at BETWEEN ? AND ?', DateTime.now.in_time_zone("Perth").beginning_of_day, DateTime.now.in_time_zone("Perth").end_of_day)
	  			if (@lessonalerttoday.size > 0)
	  				Notifier.lessonalert(u, @lessonalerttoday).deliver
	  			end
  			end
  		end  	
  	end
end
