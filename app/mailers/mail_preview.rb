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

	def manager_lesson_alert
		@date = Time.now
		@todayslessons = Lesson.all
		
		teacher_hash = {} 									# blank hash

		@todayslessons.each do |lesson| 					# group lessons by teacher
			if teacher_hash.has_key?(lesson.teacher_id) 
				teacher_hash[lesson.teacher_id] << lesson 
			else 
				teacher_hash.store(lesson.teacher_id, []) 
				teacher_hash[lesson.teacher_id] << lesson 
			end  
		end 

	end

	def teacher_lesson_alert
		@user = User.find_by_id(4)
		@date = Time.now.in_time_zone("Perth").strftime("#{Time.now.in_time_zone("Perth").day.ordinalize} %B")
		@lessonstoday = Lesson.where("student_id IS NOT NULL").limit(6)
	end







end