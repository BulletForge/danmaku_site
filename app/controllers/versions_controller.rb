class VersionsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :download]
  before_filter :require_owner, :only => [:edit, :update, :destroy]

  resource_controller
  belongs_to :project 

  destroy.wants.html {redirect_to user_project_path(@user, @project)}
  
  def download
    @user = User.find_by_permalink params[:user_id]
    raise ActiveRecord::RecordNotFound if @user.nil?    
    @project = @user.projects.find_by_permalink params[:project_id]
    raise ActiveRecord::RecordNotFound if @project.nil?
    @version = @project.versions.find_by_permalink params[:id]
    raise ActiveRecord::RecordNotFound if @version.nil?
    
    @version.download_count += 1
    @version.save
    redirect_to @version.script_bundle.url
  end

  private
  
  def object_url
    user_project_version_url(@user, @project, @version)
  end
  
  def object_path
    user_project_version_path(@user, @project, @version)
  end
  
  def edit_object_url
    edit_user_project_version_url(@user, @project, @version)
  end
  
  def edit_object_path
    edit_user_project_version_path(@user, @project, @version)
  end
  
  def new_object_url
    new_user_project_version_url(@user, @project, @version)
  end
  
  def new_object_path
    new_user_project_version_path(@user, @project, @version)
  end
  
  def collection_url
    user_project_versions_url(@user, @project)
  end
  
  def collection_path
    user_project_versions_path(@user, @project)
  end

  # Find by permalink instead of by id
  def object
    @object ||= end_of_association_chain.find_by_permalink(param)
    raise ActiveRecord::RecordNotFound if @object.nil?
    @object
  end
  
  # Find parent object by permalink instead of by id
  def parent_object
   @user ||= User.find_by_permalink(params[:user_id]) if params[:user_id]
    if @user
      @project = @user.projects.find_by_permalink(params[:project_id])
      return @project if @project
    end
    raise ActiveRecord::RecordNotFound
  end
  
  # Require the current user to be the owner of the version
  def require_owner
    user = User.find_by_permalink(params[:user_id])
    project = user.projects.find_by_permalink(params[:project_id])
    version = project.versions.find_by_permalink(params[:id])
    unless current_user.is_owner_of version
      flash[:error] = "You do not have the permissions to do that action."
      redirect_to user_project_version_path(user, project, version)
      return false
    end
  end
end
