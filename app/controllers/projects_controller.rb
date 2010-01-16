class ProjectsController < ApplicationController
  inherit_resources
  belongs_to :user, :finder => :find_by_permalink!
  
  before_filter :require_user, :except => [:index, :show]
  before_filter :require_owner, :only => [:edit, :update, :destroy]
  
  # Change redirect
  destroy! do |success, failure|
    success.html {redirect_to user_path(@user)}
  end


  private
  # Paginate the projects collection  
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.search( params[:search] ).paginate( :per_page => 10, :page => params[:page] ))
  end

  # Find by permalink instead of by id
  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.find_by_permalink!(params[:id]))
  end
  
  # Require the current user to be the owner of the project
  def require_owner
    user = User.find_by_permalink(params[:user_id])
    project = user.projects.find_by_permalink(params[:id])
    unless current_user.owner_of? project
      flash[:error] = "You do not have the permissions to do that action."
      redirect_to user_project_path(user, project)
      return false
    end
  end
  
end
