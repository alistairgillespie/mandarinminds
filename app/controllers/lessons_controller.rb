class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

  

  # GET /lessons
  # GET /lessons.json
  def index
    @lessons = Lesson.all
    @lesson = Lesson.new
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
    #render :layout => "nolayout"
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
  end

  # GET /lessons/1/edit
  def edit
  end

  #def get_lesson_details
  #  @lesson = Lesson.find(params[:id])
  #  @student = User.find(@lesson.student_id)
  #  @teacher = User.find(@lesson.teacher_id)  
  #  @data = {
  #    "lesson" => @lesson,
  #    "student" => @student,
  #    "teacher" => @teacher
  #  }  
  #  respond_to do |format|
  #    format.js { render :json => @data.to_json}
  #  end
  #end

  # POST /lessons
  # POST /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)
    @lesson.starts_at = @lesson.starts_at.beginning_of_hour


    respond_to do |format|

      if @lesson.starts_at < Time.now 
        redirect_to (lessons_path), :flash => { :error => "The time selected for the lesson slot has already passed. Please try a later time"}
        return
      end

      if @lesson.save

        format.html { redirect_to (lessons_path), notice: 'A lesson slot has been successfully created.' }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { redirect_to (lessons_path), :flash => { :error => "You already have a lesson slot booked for #{@lesson.starts_at.in_time_zone('Perth').strftime('%d/%m/%y')} at #{@lesson.starts_at.in_time_zone('Perth').strftime('%l:%M%P')}"} }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def requestlesson
    @lesson = Lesson.new(lesson_params)
    @lesson.starts_at = @lesson.starts_at.beginning_of_hour

    respond_to do |format|

      if @lesson.starts_at < Time.now 
        redirect_to (lessons_path), :flash => { :error => "The time selected for the lesson slot has already passed. Please try a later time"}
        return
      end

      if @lesson.save
        #Specific request to a teacher, notify them
        unless @lesson.teacher.nil?
          @notification_params = {
            :user_id => @lesson.teacher.id,
            :image => @lesson.student.id,
            :content => "#{@lesson.student.firstname} #{@lesson.student.lastname} has requested a lesson with you.",
            :lesson_id => @lesson.id,
            :dismissed => false,
            :appear_at => Time.now
            }
          @n = Notification.new(@notification_params)
          @n.save
          pushtopusher

        end

        format.html { redirect_to (lessons_path), notice: 'Your request has been successfully created.' }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { redirect_to (lessons_path), :flash => { :error => "You already have a request or booked lesson for #{@lesson.starts_at.in_time_zone('Perth').strftime('%d/%m/%y')} at #{@lesson.starts_at.in_time_zone('Perth').strftime('%l:%M%P')}"} }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def createlessonslot
    @lesson = Lesson.new(lesson_params)
    @lesson.starts_at = @lesson.starts_at.beginning_of_hour

    respond_to do |format|

      if @lesson.starts_at < Time.now 
        redirect_to (lessons_path), :flash => { :error => "The time selected for the lesson slot has already passed. Please try a later time"}
        return
      end

      if @lesson.save
        format.html { redirect_to (lessons_path), notice: 'Your lesson slot has been successfully created.' }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { redirect_to (lessons_path), :flash => { :error => "You already have a slot at #{@lesson.starts_at.in_time_zone('Perth').strftime('%d/%m/%y')} at #{@lesson.starts_at.in_time_zone('Perth').strftime('%l:%M%P')}"} }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json
  def update
    respond_to do |format|

      if @lesson.starts_at < Time.now 
        redirect_to (lessons_path), :flash => { :error => "That lesson has already passed. Please try a later time"}
        return
      end

      if @lesson.update(lesson_params)
        format.html { redirect_to (lessons_path), notice: 'Your lesson has been booked successfully. Check your Dashboard for your upcoming timetable' }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { redirect_to (lessons_path), :flash => { :error => "You already have a lesson booked for #{@lesson.starts_at.in_time_zone('Perth').strftime('%d/%m/%y')} at #{@lesson.starts_at.in_time_zone('Perth').strftime('%l:%M%P')}"}}
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirmlessonrequest
    @lesson = Lesson.find(params[:id])
    @lesson.confirmed = true
          @notification_params = {
            :user_id => @lesson.student.id,
            :image => @lesson.teacher.id,
            :content => "#{@lesson.teacher.firstname} #{@lesson.teacher.lastname} has confirmed a lesson with you.",
            :lesson_id => @lesson.id,
            :dismissed => false,
            :appear_at => Time.now
            }
          @n = Notification.new(@notification_params)
          @n.save
          @notification_params = {
            :user_id => @lesson.student.id,
            :image => @lesson.teacher.id,
            :content => "You have a lesson starting in 15 minutes.",
            :lesson_id => @lesson.id,
            :dismissed => false,
            :appear_at => (@lesson.starts_at - 15.minutes)
            }
          @n = Notification.new(@notification_params)
          @n.save
          @notification_params = {
            :user_id => @lesson.student.id,
            :image => @lesson.teacher.id,
            :content => "Your lesson is ready.",
            :lesson_id => @lesson.id,
            :dismissed => false,
            :appear_at => (@lesson.starts_at - 5.minutes)
            }
          @n = Notification.new(@notification_params)
          @n.save
    @lesson.save!
    redirect_to lessons_path, notice: 'Lesson was successfully confirmed'
  end

def booklessonslot
    if current_user.lesson_count < 1
      respond_to do |format|
          format.html { redirect_to lessons_url, notice: 'You do not have any lessons to spend. Visit the Plans page to purchase more.' }
          format.json { head :no_content }
      end
      return
    end
    @lesson = Lesson.find(params[:id])
    @lesson.student = current_user
    current_user.lesson_count = current_user.lesson_count - 1
          @notification_params = {
            :user_id => @lesson.teacher.id,
            :image => @lesson.student.id,
            :content => "#{@lesson.student.firstname} #{@lesson.student.lastname} has booked a lesson with you.",
            :lesson_id => @lesson.id,
            :dismissed => false,
            :appear_at => Time.now
            }
          @n = Notification.new(@notification_params)
          @n.save
          pushtopusher
          @notification_params = {
            :user_id => @lesson.student.id,
            :image => @lesson.teacher.id,
            :content => "You have a lesson starting in 15 minutes.",
            :lesson_id => @lesson.id,
            :dismissed => false,
            :appear_at => (@lesson.starts_at - 15.minutes)
            }
          @n = Notification.new(@notification_params)
          @n.save
          #Need a way to push to pusher 15min before lesson. Timed event
    @lesson.save!
    redirect_to lessons_path, notice: 'Lesson was successfully confirmed. Lessons left to spend: #{current_user.lesson_count}'
  end
  # DELETE /lessons/1
  # DELETE /lessons/1.json


  def destroy
    
    @lesson.destroy

    if @lesson.confirmed

      @lesson.notifications.where("appear_at > ?", Time.now).each do |n|
        n.destroy
      end

      @lesson.student.lesson_count = @lesson.student.lesson_count + 1

      if current_user.role_id == 1
        @notification_params = {
                :user_id => @lesson.teacher.id,
                :image => @lesson.student.id,
                :content => "#{@lesson.student.firstname} #{@lesson.student.lastname} has cancelled their lesson with you.",
                :lesson_id => @lesson.id,
                :dismissed => false,
                :appear_at => Time.now
                }
              @n = Notification.new(@notification_params)
              @n.save
              pushtopusher

        respond_to do |format|
          format.html { redirect_to lessons_url, notice: 'Lesson was successfully cancelled.' }
          format.json { head :no_content }
        end
      else

        @notification_params = {
                :user_id => @lesson.student.id,
                :image => @lesson.teacher.id,
                :content => "#{@lesson.teacher.firstname} #{@lesson.teacher.lastname} has cancelled their lesson with you. You have been credited the lesson you spent",
                :lesson_id => @lesson.id,
                :dismissed => false,
                :appear_at => Time.now
                }
              @n = Notification.new(@notification_params)
              @n.save
              pushtopusher

        respond_to do |format|
          format.html { redirect_to lessons_url, notice: 'Lesson was successfully cancelled.' }
          format.json { head :no_content }
        end
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
      params.require(:lesson).permit(:student_id, :teacher_id, :starts_at, :confirmed)
    end
end
