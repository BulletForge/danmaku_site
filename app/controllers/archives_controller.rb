class ArchivesController < ApplicationController
  def show
    @user = User.find_by_permalink! params[:user_id]
    @project = @user.projects.find_by_permalink! params[:project_id]

    if @project.script_archive && @project.script_archive.attached?
      @project.increment_download_counter!
      redirect_to @project.script_archive.service_url
    elsif @project.archive
      @project.increment_download_counter!
      redirect_to @project.archive.attachment_url
    else
      render_404
    end
  end
end
