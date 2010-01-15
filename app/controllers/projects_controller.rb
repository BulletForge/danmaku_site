class ProjectsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  before_filter :require_owner, :only => [:edit, :update, :destroy]

  resource_controller
  belongs_to :user
  
  # Change redirect
  destroy.wants.html {redirect_to user_path(@user)}
  

  private

  # Paginate the projects collection  
  def collection
    @search = end_of_association_chain.search(params[:search])
    @collection ||= @search.paginate :per_page => 10,
                                     :page => params[:page]
  end

  # Find by permalink instead of by id
  def object
    @object ||= end_of_association_chain.find_by_permalink(param)
    raise ActiveRecord::RecordNotFound if @object.nil?
    @object
  end
  
  # Find the parent object by permalink instead of by id
  def parent_object
    parent? && !parent_singleton? ? parent_model.find_by_permalink(parent_param) : nil
  end
  
  # Require the current user to be the owner of the project
  def require_owner
    user = User.find_by_permalink(params[:user_id])
    project = user.projects.find_by_permalink(params[:id])
    unless current_user.is_owner_of project
      flash[:error] = "You do not have the permissions to do that action."
      redirect_to user_project_path(user, project)
      return false
    end
  end
  
end
