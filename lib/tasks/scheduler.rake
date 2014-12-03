desc "These tasks are called by the Heroku scheduler add-on"

task :weekly_student_update => :environment do
	if Time.now.in_time_zone("Perth").strftime('%A') == 'Wednesday'
		@students = User.where("role_id = 1 AND lesson_count < 2").order(created_at: :desc)
		@inactive_users = []
		@students.each do |s|
			if Lesson.where("student_id = ?", s.id).count < 2
				@inactive_users << s
			end
		end
		Notifier.delay.weekly_student_update(@inactive_users)
	end
end

task :lesson_alert => :environment do

	@todayslessons = Lesson.where("student_id IS NOT NULL").where('starts_at BETWEEN ? AND ?', DateTime.now.utc, DateTime.now.utc + 24.hours).order(student_id: :asc, starts_at: :asc) 
	teacher_hash = {} 									# blank hash

	@todayslessons.each do |lesson| 					# group lessons by teacher
		if teacher_hash.has_key?(lesson.teacher_id) 
			teacher_hash[lesson.teacher_id] << lesson 
		else 
			teacher_hash.store(lesson.teacher_id, []) 
			teacher_hash[lesson.teacher_id] << lesson 
		end  
	end 

	Notifier.delay.manager_lesson_alert(teacher_hash)	# Send all lessons to the manager

	teacher_hash.each do |t, array|  
		Notifier.delay.teacher_lesson_alert(t, array)	# Send the teacher their lessons
	end 
	
	
	@todayslessons.each do |l| 							# Send each student their lessons
		if @lessonarray.nil? || @lessonarray[0].nil? 
			@lessonarray = [] 
			@lessonarray << l 
		elsif @lessonarray[0].student_id != l.student_id 
			Notifier.delay.lessonalert(@lessonarray[0].student_id, @lessonarray)
			@lessonarray = [] 
			@lessonarray << l 
		else 
			@lessonarray << l 
		end 
	end 

	if @lessonarray.size > 0 
		Notifier.delay.lessonalert(@lessonarray[0].student_id, @lessonarray)
	end 
end


task :notification_check_50 => :environment do
	@lessonsthishour = Lesson.where("starts_at = ?", Time.now.utc.beginning_of_hour + 1.hour)

  	@lessonsthishour.each do |h|

  		unless h.student_id.nil?
		  	@notification_params = {
		        :user_id => h.student.id,
		        :image => '<i class="fa fa-clock-o"></i>',
		        :content => "Your lesson with #{h.teacher.firstname} #{h.teacher.lastname} is ready to begin. Check your Dashboard for more information"
		    }
		    Pusher.trigger("private-#{@notification_params[:user_id]}",'lesson_alert', {"image" => @notification_params[:image],
	            "message" => @notification_params[:content], 
	            })

		    @notification_params = {
		        :user_id => h.teacher.id,
		        :image => '<i class="fa fa-clock-o"></i>',
		        :content => "Your lesson with #{h.student.firstname} #{h.student.lastname} is ready to begin. Check your Dashboard for more information"
		    }
		    Pusher.trigger("private-#{@notification_params[:user_id]}",'notification', {"image" => @notification_params[:image],
            "message" => @notification_params[:content],
            })
		end	
	end
  
end

task :notification_check_40 => :environment do
  	@lessonsthishour = Lesson.where("starts_at = ?", Time.now.utc.beginning_of_hour + 1.hour)

  	@lessonsthishour.each do |h|

  		unless h.student_id.nil?
		  	@notification_params = {
		        :user_id => h.student.id,
		        :image => '<i class="fa fa-clock-o"></i>',
		        :content => "You have a lesson beginning in 20min with #{h.teacher.firstname} #{h.teacher.lastname}. Check your Dashboard for more information"
		    }
		    Pusher.trigger("private-#{@notification_params[:user_id]}",'notification', {"image" => @notification_params[:image],
            "message" => @notification_params[:content],
            })

		    @notification_params = {
		        :user_id => h.teacher.id,
		        :image => '<i class="fa fa-clock-o"></i>',
		        :content => "You have a lesson beginning in 20min with #{h.student.firstname} #{h.student.lastname}. Check your Dashboard for more information"
		    }
		    Pusher.trigger("private-#{@notification_params[:user_id]}",'notification', {"image" => @notification_params[:image],
            "message" => @notification_params[:content],
            })
		end
	end	 
end