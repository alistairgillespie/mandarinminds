class PostsController < ApplicationController
  #before_action :set_post, only: [:show, :edit, :update, :destroy]
  respond_to :html, :js

  def view_archive
    year = params[:year]
    month = params[:month]

    if (year && month) # 2010/02
      requested_month = Date.new(year.to_i, Date.parse(month).month.to_i - 1)
      @posts = Post.where("created_at BETWEEN ? AND ?", requested_month, requested_month.end_of_month)
    elsif (year)
      requested_year = Date.new(year.to_i)
      @posts = Post.where("created_at BETWEEN ? AND ?", requested_year, requested_year.end_of_year)
    else
      @posts = []
    end

    render "archive"
  end

  # GET /posts
  # GET /posts.json
  def index
    @pagenumber = params[:pagenumber]
    @posts = Post.all.order(created_at: :desc)
    @post = Post.new
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  	@post = Post.find(params[:id])
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit	
  	 @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @posts = Post.all.order(created_at: :asc)
    @post = Post.create(post_params)
    @post.author_id = current_user.id
	  @post.save

    #    User.all.each do |u|
    #      unless u.id == @currentauthor.id
    #        @notification_params = {
    #                :user_id => u.id,
    #                :image => '<i class="fa fa-paper-plane"></i>',
    #                :content => "#{@currentauthor.firstname} #{@currentauthor.lastname} has posted a new blog entry: #{@post.title}.",
    #                :lesson_id => nil,#@post.id,
    #                :dismissed => false,
    #                :appear_at => Time.now
    #                }
    #              @n = Notification.new(@notification_params)
    #              @n.save!
    #              Pusher.trigger("private-#{@notification_params[:user_id]}",'notification', {"image" => @notification_params[:image],
    #           "message" => @notification_params[:content],
    #            })
    #      end
    redirect_to '/posts' 
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
  	@posts = Post.all
    @post = Post.find(params[:id])
    
    @post.update_attributes(post_params)
    redirect_to @post, notice: "Update successful!"
    
    #respond_to do |format|
     # if @post.update(post_params)
      #  format.html { redirect_to @post, notice: 'Post was successfully updated.' }
       # format.json { render :show, status: :ok, location: @post }
      #else
       # format.html { render :edit }
        #format.json { render json: @post.errors, status: :unprocessable_entity }
      #end
    #end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
  	@posts = Post.all
    @post = Post.find(params[:id])
    @post.destroy
  	
    
    respond_to do |format|
     format.html { redirect_to posts_url, notice: 'Post was successfully deleted.' }
     format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #def set_post
    #  @post = Post.find(params[:id])
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :author_id)
    end
end
