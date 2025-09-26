class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [ :show, :destroy ]

  # Feed: posts from self + followed users
  def index
    followed_ids = current_user.outgoing_follow_requests.select(:id)

    @posts = Post.where(user_id: [ current_user.id ] + followed_ids)
                 .order(created_at: :desc)
                 .includes(
                    :likes,
                    comments: { user: { profile: { avatar_attachment: :blob } } },
                    user: { profile: { avatar_attachment: :blob } }
                 )
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "Post created!"
    else
      render :new
    end
  end

  def destroy
    if @post.user == current_user
      @post.destroy
      redirect_to posts_path, notice: "Post deleted"
    else
      redirect_to posts_path, alert: "You can't delete this post"
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :image)
  end
end
