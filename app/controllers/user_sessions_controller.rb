class UserSessionsController < ApplicationController
  inherit_resources  
  actions :new, :create, :destroy
  
  # preload all resource / collection in before filter
  before_filter :collection, :only =>[:index]
  before_filter :resource, :only => [:show, :edit, :update, :destroy]
  before_filter :build_resource, :only => [:new, :create, :index]
  
  authorize_resource
  
  create! do |success, failure|
    success.html {
      user = UserSession.find.record
      user.ip_address = request.remote_ip
      user.save
      flash[:notice] = "Successfully logged in!"
      redirect_back_or_default root_path
    }    
    failure.html {
      render :action => :new
    }
  end
  
  destroy! do |format|
    format.html {
      flash[:notice] = "Successfully logged out!"
      redirect_back_or_default root_path      
    }
  end
  
  protected
  
  def resource
    current_user_session
  end
  
  def build_resource
    @user_session = UserSession.new(params[:user_session])
  end
  
end