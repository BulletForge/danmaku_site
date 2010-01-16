class UsersController < ApplicationController
  inherit_resources
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update, :destroy]
  before_filter :require_matching_user, :only => [:edit, :update, :destroy]
  

  # Change default flash notice and redirect
  create! do |success, failure|
    success.html {
      #flash "Successfully registered!"
      redirect_back_or_default root_path
    }
  end

  protected

  # Paginate the users collection  
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.paginate(:per_page => 10, :page => params[:page], :order => 'created_at DESC'))
  end
  
  # Find by permalink instead of by id
  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.find_by_permalink!(params[:id]))
  end
  
  # Require current user to be the user
  def require_matching_user
    user = User.find_by_permalink(params[:id])
    unless current_user == user
      flash[:error] = "You do not have the permissions to do that action."  
      redirect_to user_path(user)
      return false
    end
  end
end
