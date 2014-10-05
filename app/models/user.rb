class User < ActiveRecord::Base
  # Gravatar gem requirements
  include Gravtastic
  gravtastic

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :skypeid, length: { minimum: 1 },  :allow_blank => true



  has_many :lessons_to_attend, :class_name => 'Lesson', :foreign_key => 'student_id'
  has_many :lessons_to_teach, :class_name => 'Lesson', :foreign_key => 'teacher_id'
  has_many :charges, :class_name => 'Charge', :foreign_key => 'user_id'
  has_one :settings, :class_name => 'UserSettings', :foreign_key => 'user_id'
  has_many :notifications, :class_name => 'Notification', :foreign_key => 'user_id'
  has_many :posts, :class_name => 'Post', :foreign_key => 'author_id'
  
  #Roles an default role setup
  belongs_to :role

  
  before_create :set_default_role

  def update_card(subscriber, card_info)

    token = Stripe::Token.create(
      card: {
        number: card_info[:number],
        exp_month: card_info[:exp_month],
        exp_year: card_info[:exp_year],
        cvc: card_info[:cvc]
      }
    )
    customer = Stripe::Customer.retrieve(subscriber.stripe_id)
    card = customer.cards.create(card: token.id)
    card.save
    customer.default_card = card.id
    customer.save

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while updating card info: #{e.message}"
    errors.add :base, "#{e.message}"
    false
  rescue Stripe::CardError => e
      logger.error "You card details were not correct: #{e.message}"
      errors.add :base, "#{e.message}"
      false
  end

  
  private
  def set_default_role
  		self.role ||= Role.find_by_name('student')
  end
  
  
  
end
