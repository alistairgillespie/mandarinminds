class User < ActiveRecord::Base
  # Gravatar gem requirements
  include Gravtastic
  gravtastic

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable



  has_many :lessons_to_attend, :class_name => 'Lesson', :foreign_key => 'student_id'
  has_many :lessons_to_teach, :class_name => 'Lesson', :foreign_key => 'teacher_id'
  
  #Roles an default role setup
  belongs_to :role

  
  before_create :set_default_role
  
  private
  def set_default_role
  		self.role ||= Role.find_by_name('student')
  end
  
  
  
end
