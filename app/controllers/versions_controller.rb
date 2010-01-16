class VersionsController < ApplicationController
  inherit_resources
  belongs_to :user, :finder => :find_by_permalink! do
    belongs_to :project, :finder => :find_by_permalink!
  end
  
  before_filter :require_user, :except => [:index, :show, :download]
  before_filter :require_owner, :only => [:edit, :update, :destroy, :upload, :upload_script_bundle]
  before_filter :load_object, :only => [:upload_script_bundle, :download, :vote_up, :vote_down]


  destroy! do |success, failure|
    success.html { redirect_to user_project_path(@user, @project) }
  end

  def upload_script_bundle
    @script_bundle = Archive.new(:attachment => swf_upload_data, :attachable => @version)
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
    redirect_to @version.archive.attachment.url
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

  # Find by permalink instead of by id
  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.find_by_permalink!(params[:id]))
  end
  
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.descend_by_created_at)
  end
  
  # Require the current user to be the owner of the version
  def require_owner
    user = User.find_by_permalink(params[:user_id])
    project = user.projects.find_by_permalink(params[:project_id])
    version = project.versions.find_by_permalink(params[:id])
    unless current_user.owner_of? version
      flash[:error] = "You do not have the permissions to do that action."
      redirect_to user_project_version_path(user, project, version)
      return false
    end
  end
end
