class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  
  # GET /lessons
  # GET /lessons.json
  def index
    @lesson = Lesson.new

    if current_user.timezone_offset
      offset = current_user.timezone_offset
    else
      offset = 8
    end

    if current_user.role_id == 2
      first_day = params[:start_date]
      offset = current_user.timezone_offset
      offset ||= 8
      first_day ||= (Time.now.utc + offset.hours).strftime('%Y-%m-%d')
      first_day = Time.parse(first_day + ' 00:00:00')

      @lessons = Lesson.all.where("teacher_id = ?", current_user.id).where("starts_at > ? AND starts_at < ?", first_day - offset.hours - 1.hour, first_day - offset.hours + 8.days + 1.hour).order(starts_at: :asc)
    else #Not a teacher
      if params[:teacher]
        teacher_entry = Teacher.find_by abbr: params[:teacher]
        if teacher_entry
          teacher = User.find_by id: teacher_entry.user_id
        else
          teacher = nil
        end
          
        if teacher
          @lessons_week1 = Lesson.where("starts_at > ? AND starts_at < ?", (Time.now.utc + offset.hours).beginning_of_day - 1.second - offset.hours, (Time.now.utc + offset.hours).beginning_of_day + 7.days + 1.second - offset.hours).where("teacher_id = ? or student_id = ?", teacher.id, current_user.id).order(starts_at: :asc)
          @lessons_week2 = Lesson.where("starts_at > ? AND starts_at < ?", (Time.now.utc + offset.hours).beginning_of_day + 7.days - 1.second - offset.hours, (Time.now.utc + offset.hours).beginning_of_day + 14.days + 1.second - offset.hours).where("teacher_id = ? or student_id = ?", teacher.id, current_user.id).order(starts_at: :asc)
          @lessons_week3 = Lesson.where("starts_at > ? AND starts_at < ?", (Time.now.utc + offset.hours).beginning_of_day + 14.days - 1.second - offset.hours, (Time.now.utc + offset.hours).beginning_of_day + 21.days + 1.second - offset.hours).where("teacher_id = ? or student_id = ?", teacher.id, current_user.id).order(starts_at: :asc)
          @lessons_week4 = Lesson.where("starts_at > ? AND starts_at < ?", (Time.now.utc + offset.hours).beginning_of_day + 21.days - 1.second - offset.hours, (Time.now.utc + offset.hours).beginning_of_day + 28.days + 1.second - offset.hours).where("teacher_id = ? or student_id = ?", teacher.id, current_user.id).order(starts_at: :asc)
        else
          @lessons_week1 = Lesson.where("starts_at > ? AND starts_at < ?", (Time.now.utc + offset.hours).beginning_of_day - 1.second - offset.hours, (Time.now.utc + offset.hours).beginning_of_day + 7.days + 1.second - offset.hours).order(starts_at: :asc)
          @lessons_week2 = Lesson.where("starts_at > ? AND starts_at < ?", (Time.now.utc + offset.hours).beginning_of_day + 7.days - 1.second - offset.hours, (Time.now.utc + offset.hours).beginning_of_day + 14.days + 1.second - offset.hours).order(starts_at: :asc)
          @lessons_week3 = Lesson.where("starts_at > ? AND starts_at < ?", (Time.now.utc + offset.hours).beginning_of_day + 14.days - 1.second - offset.hours, (Time.now.utc + offset.hours).beginning_of_day + 21.days + 1.second - offset.hours).order(starts_at: :asc)
          @lessons_week4 = Lesson.where("starts_at > ? AND starts_at < ?", (Time.now.utc + offset.hours).beginning_of_day + 21.days - 1.second - offset.hours, (Time.now.utc + offset.hours).beginning_of_day + 28.days + 1.second - offset.hours).order(starts_at: :asc)
          redirect_to lessons_path, notice: "Teacher '#{params[:teacher]}' not found."
        end
      else
        @lessons_week1 = Lesson.where("starts_at > ? AND starts_at < ?", (Time.now.utc + offset.hours).beginning_of_day - 1.second - offset.hours, (Time.now.utc + offset.hours).beginning_of_day + 7.days + 1.second - offset.hours).order(starts_at: :asc)
        @lessons_week2 = Lesson.where("starts_at > ? AND starts_at < ?", (Time.now.utc + offset.hours).beginning_of_day + 7.days - 1.second - offset.hours, (Time.now.utc + offset.hours).beginning_of_day + 14.days + 1.second - offset.hours).order(starts_at: :asc)
        @lessons_week3 = Lesson.where("starts_at > ? AND starts_at < ?", (Time.now.utc + offset.hours).beginning_of_day + 14.days - 1.second - offset.hours, (Time.now.utc + offset.hours).beginning_of_day + 21.days + 1.second - offset.hours).order(starts_at: :asc)
        @lessons_week4 = Lesson.where("starts_at > ? AND starts_at < ?", (Time.now.utc + offset.hours).beginning_of_day + 21.days - 1.second - offset.hours, (Time.now.utc + offset.hours).beginning_of_day + 28.days + 1.second - offset.hours).order(starts_at: :asc)
      end
    end
  end

  def get_users_next_lesson
    #respond_to do |format|    
      @data = nil
      if user_signed_in?
        if current_user.role_id == 1 #student
          @data = Lesson.where("student_id = ? AND starts_at > ?", current_user.id, Time.now - 15.minutes).order(starts_at: :asc).first
        elsif current_user.role_id == 2 #teacher
          @data = Lesson.where("teacher_id = ? AND starts_at > ?", current_user.id, Time.now - 15.minutes).order(starts_at: :asc).first
        end
      end
      render :json => @data.to_json
    #end
  end

  def add_multiple_lessons
    offset = current_user.timezone_offset
    offset ||= 8
    start_time = Time.utc(params[:start][:year].to_i, params[:start][:month].to_i, params[:start][:day].to_i, params[:start][:hour].to_i,0,0) - offset.hours
    num = params[:end][:hour].to_i - params[:start][:hour].to_i + 1

    if num < 1
      redirect_to lessons_path, notice: "Invalid times. 'To' cannot be earlier than 'From'"
      return
    end

    if (Time.now + 48.hours) > start_time
      redirect_to lessons_path, notice: "You cannot open lesson slots that are less than 48 hours away"
      return
    end

    unless current_user.role_id == 2
      redirect_to lessons_path, notice: "Only teachers may open lesson slots"
      return
    end

    skipped = 0
    created = 0

    for j in 0..(params[:repeat].to_i - 1)
      for i in 0..(num - 1)
        if Lesson.where("teacher_id = ? and starts_at = ?", current_user.id, start_time + j.days + i.hours).count() > 0
          skipped += 1
        else
          Lesson.create(:teacher_id => current_user.id, :starts_at => start_time + j.days + i.hours)
          created += 1
        end
      end
    end

    date_string = start_time.strftime("#{start_time.day.ordinalize} %b %Y")
    redirect_to lessons_path, notice: "#{created} lesson(s) added on the #{params[:repeat]} day(s) starting from #{date_string} successfully. #{skipped} existing lesson slot(s) were skipped"
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show

    if current_user.id != @lesson.student_id && current_user.id != @lesson.teacher_id
            redirect_to (lessons_path), :flash => { :error => "You do not have permission to view that lesson."}
    end

  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
  end

  # GET /lessons/1/edit
  def edit
  end

  # POST /lessons
  # POST /lessons.json
  def create
    
      offset = current_user.timezone_offset
      offset ||= 8

      @lesson = Lesson.new(lesson_params)
      @lesson.starts_at = @lesson.starts_at.beginning_of_hour

      if @lesson.starts_at < Time.now 
        redirect_to (lessons_path), :flash => { :error => "The time selected for the lesson slot has already passed. Please try a later time"}
        return
      end

      respond_to do |format|
        if Lesson.where("teacher_id = ? AND starts_at = ?", @lesson.teacher_id, @lesson.starts_at).count == 0
          @lesson.save
          format.html { redirect_to (lessons_path), notice: 'A lesson slot has been successfully created.' }
          format.json { render :show, status: :created, location: @lesson }
        else
          format.html { redirect_to (lessons_path), :flash => { :error => "You already have a lesson slot booked for #{(@lesson.starts_at + offset.hours).strftime('%d/%m/%y')} at #{(@lesson.starts_at + offset.hours).strftime('%l:%M%P')}"} }
          format.json { render json: @lesson.errors, status: :unprocessable_entity }
        end
      end


  end

  def createlessonslot
    offset = current_user.timezone_offset
      offset ||= 8

      @lesson = Lesson.new(lesson_params)
      @lesson.starts_at = @lesson.starts_at.beginning_of_hour

      if @lesson.starts_at < Time.now 
        redirect_to (lessons_path), :flash => { :error => "The time selected for the lesson slot has already passed. Please try a later time"}
        return
      end

      respond_to do |format|
        if Lesson.where("teacher_id = ? AND starts_at = ?", @lesson.teacher_id, @lesson.starts_at).count == 0
          @lesson.save
          format.html { redirect_to (lessons_path), notice: 'A lesson slot has been successfully created.' }
          format.json { render :show, status: :created, location: @lesson }
        else
          format.html { redirect_to (lessons_path), :flash => { :error => "You already have a lesson slot booked for #{(@lesson.starts_at + offset.hours).strftime('%d/%m/%y')} at #{(@lesson.starts_at + offset.hours).strftime('%l:%M%P')}"} }
          format.json { render json: @lesson.errors, status: :unprocessable_entity }
        end
      end


  end

  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json

  def update
    respond_to do |format|

      if @lesson.update(lesson_params)
        format.html { redirect_to :back, notice: 'Your lesson has been updated successfully.' }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { redirect_to :back, :flash => { :error => "An error occured while trying to update"}}
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def booklessonslot

    if ( current_user.lesson_count.nil? || current_user.lesson_count < 1)
      respond_to do |format|
          format.html { redirect_to lessons_url, notice: 'You do not have any lessons to spend. Visit the Plans page to purchase more.' }
          format.json { head :no_content }
      end
      return
    end

    @lesson = Lesson.find(params[:id])

    unless @lesson.student_id.nil?
      respond_to do |format|
          format.html { redirect_to lessons_url, notice: 'Sorry, that lesson has already been booked by another student. Please try another' }
          format.json { head :no_content }
      end
    end

    @lesson.student = current_user

    teacher_offset = @lesson.teacher.timezone_offset
    teacher_offset ||= 8
    student_offset = @lesson.student.timezone_offset
    student_offset ||= 8

    if teacher_offset >= 0
      teachertimezone = "(UTC +#{teacher_offset})"
    else
      teachertimezone = "(UTC -#{teacher_offset})"
    end

    if student_offset >= 0
      studenttimezone = "(UTC +#{student_offset})"
    else
      studenttimezone = "(UTC -#{student_offset})"
    end
    
    @teacherstarttime = (@lesson.starts_at + teacher_offset.hours).strftime("%l:%M%P on the #{(@lesson.starts_at + teacher_offset.hours).day.ordinalize} %B %Y #{teachertimezone}")
    @studentstarttime = (@lesson.starts_at + student_offset.hours).strftime("%l:%M%P on the #{(@lesson.starts_at + student_offset.hours).day.ordinalize} %B %Y #{studenttimezone}")
    current_user.lesson_count = current_user.lesson_count - 1
    current_user.save!
          @notification_params = {
            :user_id => @lesson.teacher.id,
            :image => '<i class="fa fa-book"></i>',
            :content => "#{@lesson.student.firstname} #{@lesson.student.lastname} has booked a lesson with you at #{@teacherstarttime}",
            :link => "lessons/#{@lesson.id}",
            :lesson_id => @lesson.id,
            :dismissed => false
            }
          @n = Notification.new(@notification_params)
          @n.save
          pushtopusher
          @notification_params = {
            :user_id => @lesson.student.id,
            :image => '<i class="fa fa-book"></i>',
            :content => "You have booked a lesson with #{@lesson.teacher.firstname} #{@lesson.teacher.lastname} at #{@studentstarttime}",
            :link => "lessons/#{@lesson.id}",
            :lesson_id => @lesson.id,
            :dismissed => true
            }
          @n = Notification.new(@notification_params)
          @n.save
    @lesson.save!
    redirect_to lessons_path(:teacher => params[:teacher]), notice: "Lesson was successfully confirmed."
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.json

  def destroy

    @lesson.destroy!
    
    unless @lesson.student_id.nil?
      @lesson.notifications.each do |n|
          n.lesson_id = 0
          n.link = nil
          n.save!
      end
    end

    unless @lesson.teacher_id.nil?
      teacher_offset = @lesson.teacher.timezone_offset
    end

    unless @lesson.student_id.nil?
      student_offset = @lesson.student.timezone_offset
    end

    teacher_offset ||= 8
    student_offset ||= 8

    if teacher_offset >= 0
      teachertimezone = "(UTC +#{teacher_offset})"
    else
      teachertimezone = "(UTC -#{teacher_offset})"
    end

    if student_offset >= 0
      studenttimezone = "(UTC +#{student_offset})"
    else
      studenttimezone = "(UTC -#{student_offset})"
    end

    @teacherstarttime = (@lesson.starts_at + teacher_offset.hours).strftime("%l:%M%P on the #{(@lesson.starts_at + teacher_offset.hours).day.ordinalize} %B %Y #{teachertimezone}")
    @studentstarttime = (@lesson.starts_at + student_offset.hours).strftime("%l:%M%P on the #{(@lesson.starts_at + student_offset.hours).day.ordinalize} %B %Y #{studenttimezone}")
    
    #IF the student cancels their lesson
    if current_user.role_id == 1
      @studentmessage = "You have cancelled your lesson with #{@lesson.teacher.firstname} #{@lesson.teacher.lastname} at #{@studentstarttime}. You have been credited a lesson."

      if @lesson.starts_at < Time.now + 24.hours #student will not be refunded a lesson
        @studentmessage = "You have cancelled your lesson with #{@lesson.teacher.firstname} #{@lesson.teacher.lastname} at #{@studentstarttime}. As you cancelled it within 24h of the start time you have not been credited the lesson."
      else
        @lesson.student.lesson_count = @lesson.student.lesson_count + 1
        @lesson.student.save!
      end

      @notification_params = {
              :user_id => @lesson.student.id,
              :image => '<i class="fa fa-ban"></i>',                
              :content => @studentmessage,
              :lesson_id => 0,
              :link => nil,
              :dismissed => true
              }
            @n = Notification.new(@notification_params)
            @n.save!
      @notification_params = {
              :user_id => @lesson.teacher.id,
              :image => '<i class="fa fa-ban"></i>',
              :content => "#{@lesson.student.firstname} #{@lesson.student.lastname} has cancelled their lesson with you at #{@teacherstarttime}. A new blank lesson slot has been created in its place.",
              :lesson_id => 0,
              :link => nil,
              :dismissed => false
              }
            @n = Notification.new(@notification_params)
            @n.save!
            pushtopusher

      #Create replacement lesson because student cancelled
      @newLesson = Lesson.new
      @newLesson.starts_at = @lesson.starts_at
      @newLesson.teacher_id = @lesson.teacher_id
      @newLesson.save!

      respond_to do |format|
        format.html { redirect_to lessons_path(:teacher => params[:teacher]), notice: "Lesson was successfully cancelled."}
        format.json { head :no_content }
      end

    #ELSE if the teacher cancels the lesson  
    else

      if @lesson.student
        @lesson.student.lesson_count = @lesson.student.lesson_count + 1
        @lesson.student.save!
      
        @notification_params = {
                :user_id => @lesson.student.id,
                :image => '<i class="fa fa-ban"></i>',
                :content => "#{@lesson.teacher.firstname} #{@lesson.teacher.lastname} has cancelled their lesson with you at #{@studentstarttime}. You have been credited the lesson you spent.",
                :lesson_id => 0,
                :link => nil,
                :dismissed => false
                }
              @n = Notification.new(@notification_params)
              @n.save!
              pushtopusher
        @notification_params = {
                :user_id => @lesson.teacher.id,
                :image => '<i class="fa fa-ban"></i>',
                :content => "You have cancelled your lesson with #{@lesson.student.firstname} #{@lesson.student.lastname} at #{@teacherstarttime}. The student has been notified.",
                :lesson_id => 0,
                :link => nil,
                :dismissed => true
                }
              @n = Notification.new(@notification_params)
              @n.save!
      end
      
      respond_to do |format|
        format.html { redirect_to lessons_path(:teacher => params[:teacher]), notice: 'Lesson was successfully cancelled.' }
        format.json { head :no_content }
      end
    end
  end

  def pushtopusher
    Pusher.trigger("private-#{@notification_params[:user_id]}",'notification', {"image" => @notification_params[:image],
            "message" => @notification_params[:content],
            })
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def lesson_params
    params.require(:lesson).permit(:student_id, :teacher_id, :starts_at, :status, :comment)
  end  
    
end
