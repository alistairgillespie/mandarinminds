class LessonStatus < ActiveRecord::Base
	has_many :lessons, :class_name => 'Lesson', :foreign_key => 'status'
end
