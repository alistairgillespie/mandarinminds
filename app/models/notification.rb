class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :lesson

  def self.check45
  	@lessonsthishour = Lesson.where("starts_at = ?", Time.now.beginning_of_hour + 1.hour)

  	@lessonsthishour.each do |h|

  		unless h.student_id.nil?
		  	@notification_params = {
		        :user_id => h.student.id,
		        :image => '<i class="fa fa-clock-o"></i>',
		        :content => "You have a lesson beginning in 15min with #{h.teacher.firstname} #{h.teacher.lastname}. Check your Dashboard for more information"
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

  def self.check55

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

end
