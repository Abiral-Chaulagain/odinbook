class UsersController < ApplicationController
  def index
    @users = User.where.not(id: current_user.id).includes(profile: { avatar_attachment: :blob })
  end

  def show
    @user = User.find(params[:id])
    @profile = @user.profile
    @posts = @user.posts.order(created_at: :desc)
                        .includes(
                                  :likes,
                                  comments: { user: { profile: { avatar_attachment: :blob } } },
                                  user: { profile: { avatar_attachment: :blob } }
                        )
  end
end
