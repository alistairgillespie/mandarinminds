class MailPreview < MailView

	def welcome
	      user = User.first
	      mail = UserMailer.welcome(user)
	      mail
	end
    
end