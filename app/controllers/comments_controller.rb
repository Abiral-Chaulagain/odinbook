class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_back fallback_location: posts_path, notice: "Comment added!"
    else
      redirect_back fallback_location: posts_path, alert: "Failed to add comment."
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_back fallback_location: posts_path, notice: "Comment deleted"
    else
      redirect_back fallback_location: posts_path, alert: "You can't delete this comment"
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
