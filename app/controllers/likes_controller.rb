class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @like = @post.likes.find_or_initialize_by(user: current_user)
    if @like.save
      redirect_back fallback_location: posts_path
    else
      redirect_back fallback_location: posts_path, alert: "Unable to like post"
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    @like&.destroy
    redirect_back fallback_location: posts_path
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
