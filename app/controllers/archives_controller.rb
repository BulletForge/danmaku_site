class ArchivesController < ApplicationController
  def show
    @user = User.find_by_permalink! params[:user_id]
    @project = @user.projects.find_by_permalink! params[:project_id]
    @project.increment_download_counter!

    redirect_to @project.archive.attachment_url
  end

  def create
    @user = User.find_by_permalink! params[:user_id]
    @project = @user.projects.find_by_permalink! params[:project_id]
    @archive = Archive.new permitted_params[:archive]

    @archive.import_s3_data
    @archive.attachable = @project

    if @archive.save
      str = render_to_string template: 'projects/_archive', locals: { user: @user, project: @project }, layout: false
      render json: {
        success: true,
        replace_dom: '#archive',
        partial: str
      }
    else
      render json: { success: false, errors: @archive.errors }
    end
  end

  def destroy
    @user = User.find_by_permalink! params[:user_id]
    @project = @user.projects.find_by_permalink! params[:project_id]
    @archive = @project.archive

    @archive.destroy
    redirect_to user_project_path(@user, @project)
  end

  private

  def permitted_params
    params.permit(archive: {})
  end
end
