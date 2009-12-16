class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  resource_controller

  create do
    flash "Successfully registered!"
    wants.html {redirect_to root_path}
    
    failure.wants.html {render new_user_path}
  end
end
