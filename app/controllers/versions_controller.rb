class VersionsController < ApplicationController
  # Versions are no longer used. Just redirect to the project page.
  def redirect
    @user = User.find_by_permalink!(params[:user_id])
    @project = @user.projects.find_by_permalink!(params[:project_id])

    redirect_to user_project_path(@user, @project)
  end
end
