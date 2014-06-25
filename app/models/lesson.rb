class Lesson < ActiveRecord::Base
  belongs_to :student, :class_name => 'User', inverse_of: :lessons_to_attend
  belongs_to :teacher, :class_name => 'User', inverse_of: :lessons_to_teach
end
