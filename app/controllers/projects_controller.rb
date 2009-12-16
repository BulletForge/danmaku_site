class ProjectsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  before_filter :require_owner, :only => [:edit, :update, :destroy]

  resource_controller
  belongs_to :user
  
  destroy.wants.html {redirect_to projects_path}
  create.wants.html {redirect_to user_project_path(current_user, @project)}
  
  private
  
  def require_owner
    unless current_user.is_owner_of Project.find(params[:id])
      flash[:error] = "You do not have the permissions to do that action."
      redirect_to(project_path(params[:id]))
      return false
    end
  end
  
end
