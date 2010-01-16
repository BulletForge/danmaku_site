class VersionsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :download]
  before_filter :require_owner, :only => [:edit, :update, :destroy, :upload, :upload_script_bundle]
  before_filter :load_object, :only => [:upload_script_bundle, :download, :vote_up, :vote_down]

  resource_controller
  belongs_to :project 

  destroy.wants.html {redirect_to user_project_path(@user, @project)}

  def upload_script_bundle
    @script_bundle = Asset.new(:attachment => swf_upload_data, :attachable => @version)
    if @script_bundle.save
      flash[:notice] = "File uploaded successfully"
      render :update do |page|
        page.redirect_to :action => 'show'
      end
    else
      render :js => "uploadFailed('#{@script_bundle.error.full_message}')"
    end
  end
  
  def download
    @version.update_attributes(:download_count => @version.download_count += 1)
    @project.update_attributes(:downloads => @project.download_count)
    redirect_to @version.asset.attachment.url
  end

  def vote_up
    current_user.vote_for @version
    @project.update_attributes(:rating => @project.total_combined_votes)
    redirect_to user_project_version_path(@user, @project, @version)
  end

  def vote_down
    current_user.vote_against @version
    @project.update_attributes(:rating => @project.total_combined_votes)
    redirect_to user_project_version_path(@user, @project, @version)
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

  def collection
    @collection ||= end_of_association_chain.descend_by_created_at
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
