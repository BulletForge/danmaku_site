class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update, :destroy]
  before_filter :require_matching_user, :only => [:edit, :update, :destroy]
  
  resource_controller

  # Change default flash notice and redirect
  create do
    flash "Successfully registered!"
    wants.html {redirect_back_or_default root_path}
  end
  

  private

  # Paginate the users collection  
  def collection
    @collection ||= end_of_association_chain.paginate :per_page => 10,
                                                      :page => params[:page], 
                                                      :order => 'created_at DESC'
  end
  
  # Find by permalink instead of by id
  def object
    @object ||= end_of_association_chain.find_by_permalink(param)
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
