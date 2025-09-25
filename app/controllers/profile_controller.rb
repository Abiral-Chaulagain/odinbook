class ProfileController < ApplicationController
  def edit
    @user = User.find(current_user.id)
    @profile = @user.profile
  end

  def update
    @profile = Profile.find(params[:id])
    @profile.update(profile_params)
    redirect_back fallback_location: edit_user_profile_path
  end
end

private

def profile_params
  params.require(:profile).permit(:avatar, :display_name, :location, :bio)
end
