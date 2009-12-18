class VersionsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  before_filter :require_owner, :only => [:edit, :update, :destroy]

  resource_controller
  belongs_to :project
  
  # Create @user instance variable manually because deeply nested resources
  # aren't supported by resource_controller
  [new_action, create, index, show, edit, update, destroy].each do |action|
    action.before do
      @user = @project.user
    end
  end
  
  # Redirect to the correct path to override incorrect default.
  [create, update].each do |action|
    action.wants.html { redirect_to user_project_version_path(@user, @project, @version) }
  end
  
  destroy.wants.html { redirect_to user_project_path(@user, @project) }
  

  private

  # Find by permalink instead of by id
  def object
    @object ||= end_of_association_chain.find_by_permalink(params[:id])
  end
  
  # Find parent object by permalink instead of by id
  def parent_object
    parent? && !parent_singleton? ? parent_model.find_by_permalink(parent_param) : nil
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
