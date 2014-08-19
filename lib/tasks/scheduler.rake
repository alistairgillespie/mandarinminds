desc "These tasks are called by the Heroku scheduler add-on"

task :lesson_alert => :environment do
	User.where("role_id = 1").each do |u|
  		@lessonalerttoday = u.lessons_to_attend.where('starts_at BETWEEN ? AND ?', DateTime.now.beginning_of_day + 24.hours, DateTime.now.end_of_day + 24.hours)
  		if (@lessonalerttoday.size > 0)
  			Notifier.lessonalert(u, @lessonalerttoday).deliver
  		end
  	end 
  
end

task :notification_check_50 => :environment do
	@lessonsthishour = Lesson.where("starts_at = ?", Time.now.beginning_of_hour + 1.hour)

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
		end	
	end
  
end

task :notification_check_40 => :environment do
  	@lessonsthishour = Lesson.where("starts_at = ?", Time.now.beginning_of_hour + 1.hour)

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
		        :content => "You have a lesson beginning in 15min with #{h.student.firstname} #{h.student.lastname}. Check your Dashboard for more information"
		    }
		    Pusher.trigger("private-#{@notification_params[:user_id]}",'notification', {"image" => @notification_params[:image],
            "message" => @notification_params[:content],
            })
		end
	end	 
end