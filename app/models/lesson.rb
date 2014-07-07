class Lesson < ActiveRecord::Base
	extend SimpleCalendar
  	has_calendar
	belongs_to :student, :class_name => 'User', inverse_of: :lessons_to_attend
	belongs_to :teacher, :class_name => 'User', inverse_of: :lessons_to_teach

	validates :starts_at, :uniqueness => {:scope => :teacher_id, :message => 'You cannot teach two lessons at the same time'}
	validates :starts_at, :uniqueness => {:scope => :student_id, :message => 'You cannot book two lessons at the same time'}
end
