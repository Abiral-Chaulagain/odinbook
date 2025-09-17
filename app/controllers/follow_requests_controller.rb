class FollowRequestsController < ApplicationController
  def create
    @follow = current_user.active_follow_requests.build(followee_id: params[:followee_id])
    if @follow.save
      redirect_back fallback_location: users_path, notice: "Follow request sent."
    else
      redirect_back fallback_location: users_path, alert: "Unable to send request."
    end
  end

  def update
    @follow = FollowRequest.find(params[:id])
    if @follow.update(status: :accepted)
      redirect_back fallback_location: root_path, notice: "Follow accepted."
    else
      redirect_back fallback_location: root_path, alert: "Unable to accept."
    end
  end

  def destroy
    @follow = current_user.active_follow_requests.find_by(followee_id: params[:followee_id])
    @follow&.destroy
    redirect_back fallback_location: users_path
  end
end
