class User < ActiveRecord::Base
  # Gravatar gem requirements
  include Gravtastic
  gravtastic

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :skypeid, length: { minimum: 1 }



  has_many :lessons_to_attend, :class_name => 'Lesson', :foreign_key => 'student_id'
  has_many :lessons_to_teach, :class_name => 'Lesson', :foreign_key => 'teacher_id'
  has_many :charges, :class_name => 'Charge', :foreign_key => 'user_id'
  has_one :settings, :class_name => 'UserSettings', :foreign_key => 'user_id'
  has_many :notifications, :class_name => 'Notification', :foreign_key => 'user_id'
  has_many :posts, :class_name => 'Post', :foreign_key => 'author_id'
  
  #Roles an default role setup
  belongs_to :role

  
  before_create :set_default_role
  
  private
  def set_default_role
  		self.role ||= Role.find_by_name('student')
  end
  
  
  
end
