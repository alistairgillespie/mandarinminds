class MailPreview < MailView

def welcome
	user = User.first
	Notifier.welcome(user).deliver
end

def lesson_alert
	user = User.first
	@lessonalerttoday = Lesson.limit(3)
	Notifier.lessonalert(user, @lessonalerttoday).deliver
end

def receipt
end

def purchase_summary
	@purchases = Charge.limit(5)
	Notifier.purchase_summary(@purchases).deliver
end






end