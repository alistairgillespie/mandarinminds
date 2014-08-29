class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  #before_action :authenticate_user! 

  

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show  	  	
  	if params[:id]
    	@user = User.find(params[:id])
    else
    	@user = current_user
    end

    if @user.role_id == 1 
      @userlessons = @user.lessons_to_attend.where("starts_at > ? AND teacher_id IS NOT NULL", Time.now.advance(:hours => -1)).order(starts_at: :asc)
    elsif @user.role_id == 2
      @userlessons = @user.lessons_to_teach.where("starts_at > ? AND student_id IS NOT NULL", Time.now.advance(:hours => -1)).order(starts_at: :asc)
    end
      
    unless @user == current_user
      redirect_to :back, :alert => "Access denied."
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
    UserMailer.welcome(@user).deliver

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
      params.require(:user).permit(:email, :password, :password_confirmation)

    end
end
