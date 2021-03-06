class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  #before_action :authenticate_user! 

  def edit_card
    @user = current_user
  end

  def update_card
    @user = current_user
    
    card_info = {
      number:    "#{params[:number1]}#{params[:number2]}#{params[:number3]}#{params[:number4]}",
      exp_month: params[:date][:month],
      exp_year:  params[:date][:year],
      cvc:       params[:cvc]
    }
    if @user.update_card(@user, card_info)
      flash[:success] = 'Saved. Your card information has been updated.'
      redirect_to "/dashboard"
    else
      flash[:warning] = 'Stripe reported an error while updating your card. Please try again.'
      redirect_to "/users/edit"
    end
  end

  def cancel_dudu
    if params[:stripe_id]
      begin

        user = User.find_by stripe_id: params[:stripe_id]
        if user
          user.settings.update_attribute(:purchased_dudu, false)
        end

        sub = Stripe::Customer.retrieve(params[:stripe_id]).subscriptions.first
        if sub
          sub.delete
          redirect_to "/dashboard", notice: "Your request to cancel your subscription has been submitted. You will be notified when it has been processed successfully."
        else
          redirect_to "/dashboard", notice: "You don't have a subscription to cancel."
        end

      rescue Stripe::InvalidRequestError => e
        redirect_to "/dashboard", notice: "#{e.message}"
      end
    else
      redirect_to "/dashboard", notice: "An error occured"
    end
  end

  def promote_to_teacher
    unless user_signed_in? && current_user.role_id == 3
      redirect_to teachers_path, notice: "Access Denied"
      return
    end

    if params[:id] 
      promotee = User.find_by id: params[:id]
      promotee.update_attribute(:role_id, 2)
      Teacher.create(:user_id => promotee.id, :description => "", :show_on_page => false, :show_in_dropdown => false, :abbr => "")
      redirect_to teachers_path, notice: "Successfully promoted #{params[:email]}"
      return      
    else
      promotee = User.find_by email: params[:email]
      if promotee
        redirect_to teachers_path(confirm: true, id: promotee.id), notice: "Please confirm the teacher's details below to promote them." 
        return   
      else
        redirect_to teachers_path, notice: "Could not find a person with the email: #{params[:email]}"
        return
      end      
    end
    redirect_to teachers_path, notice: "An error occured."
  end

  def demote_to_student
    unless user_signed_in? && current_user.role_id == 3
      redirect_to teachers_path, notice: "Access Denied"
      return
    end

    if params[:teacher]
      demotee = User.find_by id: params[:teacher]
      teacher = Teacher.find_by user_id: params[:teacher]
      teacher.destroy
      if demotee
        demotee.update_attribute(:role_id, 1)
        redirect_to teachers_path, notice: "#{demotee.firstname} #{demotee.lastname} has been demoted to a student"
        return
      end
    end

    redirect_to teachers_path, notice: "An error occured. Teacher not found"
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json

  def dashboard
    if user_signed_in?
      @user = current_user
    else
      redirect_to '/'
      return
    end

    offset = current_user.timezone_offset
    offset ||= 8

    if @user.role_id == 2 
      @userlessons = Lesson.where("teacher_id = ? AND starts_at > ? AND student_id IS NOT NULL", @user.id, ((Time.now.utc + offset.hours).beginning_of_day - 1.hour - offset.hours)).order(starts_at: :asc)
    else
      @userlessons = Lesson.where("student_id = ? AND starts_at > ? AND teacher_id IS NOT NULL", @user.id, ((Time.now.utc + offset.hours).beginning_of_day - 1.hour - offset.hours)).order(starts_at: :asc)
    end
    
    
    if @userlessons.size == 0 && @user.lesson_count == 0
      @count = 0
    else
      @count = @userlessons.size.to_f
      @total = @user.lesson_count  
    end

    render "show"
  end

  def show  	  	
  	if params[:id]
    	@user = User.find(params[:id])
    else
    	@user = current_user
    end

    if @user != current_user
      if current_user.role_id > 1
      render "admin_show"
      else
      redirect_to :back, :alert => "Access denied."
      end
    end

    if @user.role_id == 1 
      @userlessons = @user.lessons_to_attend.where("starts_at > ? AND teacher_id IS NOT NULL", Time.now.utc.advance(:hours => -1)).order(starts_at: :asc)
    elsif @user.role_id == 2
      @userlessons = @user.lessons_to_teach.where("starts_at > ? AND student_id IS NOT NULL", Time.now.utc.advance(:hours => -1)).order(starts_at: :asc)
    else
      @userlessons = []
    end
    
    if @userlessons.size == 0 && @user.lesson_count == 0
  		@count = 0
  	else
  		@count = @userlessons.size.to_f
  		@total = @user.lesson_count  
  	end

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
      
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      #params[:user]
      params.require(:user).permit(:email, :password, :password_confirmation, :stripe_id, :referred_by)

    end
end
