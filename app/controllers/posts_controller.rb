class PostsController < ApplicationController
  #before_action :set_post, only: [:show, :edit, :update, :destroy]
  respond_to :html, :js
  # GET /posts
  # GET /posts.json
  def index
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
    @post.author = current_user.id
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
  	
    #@post.destroy
    #respond_to do |format|
     # format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #def set_post
    #  @post = Post.find(params[:id])
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :author)
    end
end
