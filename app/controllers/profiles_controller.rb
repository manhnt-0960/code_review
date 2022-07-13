class ProfilesController < ApplicationController
  def show
    return unless params[:setup_action] == "install"
    flash[:success] = t "notifications.processing_repositories"
    redirect_to profile_path
  end

  def update
    if current_user.update user_params
      flash[:success] = "Updated"
    else
      flash[:danger] = current_user.errors.full_messages.first
    end

    redirect_to profile_path
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit :room_id, :language, :slack_id
  end
end
