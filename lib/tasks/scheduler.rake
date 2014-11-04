desc "These tasks are called by the Heroku scheduler add-on"

task :lesson_alert => :environment do

	@todayslessons = Lesson.where("student_id IS NOT NULL").where('starts_at BETWEEN ? AND ?', DateTime.now.utc, DateTime.now.utc + 24.hours).order("student_id") 
	@todayslessons.each do |l| 
		if @lessonarray.nil? || @lessonarray[0].nil? 
			@lessonarray = [] 
			@lessonarray << l 
		elsif @lessonarray[0].student_id != l.student_id 
			Notifier.lessonalert(@lessonarray[0].student_id, @lessonarray).deliver
			@lessonarray = [] 
			@lessonarray << l 
		else 
			@lessonarray << l 
		end 
	end 
	if @lessonarray.size > 0 
		Notifier.lessonalert(@lessonarray[0].student_id, @lessonarray).deliver
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