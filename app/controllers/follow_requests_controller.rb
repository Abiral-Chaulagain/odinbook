class FollowRequestsController < ApplicationController
  def index
    @incoming_follows = current_user.passive_follow_requests.where(status: 0)
                                                            .includes(follower: { profile: { avatar_attachment: :blob } })
                                                            .order(created_at: :desc)
    @outgoing_follows = current_user.active_follow_requests.where(status: 0)
                                                           .includes(followee: { profile: { avatar_attachment: :blob } })
                                                           .order(created_at: :desc)
    @follows = current_user.active_follow_requests.where(status: 1)
                                                  .includes(followee: { profile: { avatar_attachment: :blob } })
                                                  .order(created_at: :desc)
  end

  def create
    @follow = current_user.active_follow_requests.build(followee_id: params[:followee_id], status: 0)
    if @follow.save
      redirect_back fallback_location: users_path, notice: "Follow request sent."
    else
      redirect_back fallback_location: users_path, alert: "Unable to send request."
    end
  end

  def update
    @follow = FollowRequest.find(params[:id])
    update_status = params[:update]
    case update_status
    when "accepted"
      @follow.status="accepted"
      @follow.save
    when "declined"
      @follow.status="declined"
      @follow.save
    end
    redirect_back fallback_location: follow_requests_path
  end

  def destroy
    @follow = FollowRequest.find_by(id: params[:id])
    @follow&.destroy
    redirect_back fallback_location: users_path
  end
end
