class UsersController < ApplicationController
  inherit_resources
  include PermalinkResources
  
  # preload all resource / collection in before filter
  before_filter :collection, :only =>[:index]
  before_filter :resource, :only => [:show, :edit, :update, :destroy]
  before_filter :build_resource, :only => [:new, :create, :index]
  
  authorize_resource
  

  # Change default flash notice and redirect
  create! do |success, failure|
    success.html {
      #flash "Successfully registered!"
      redirect_back_or_default root_path
    }
  end

  protected
  # Paginate the users collection  
  def _collection
    end_of_association_chain.paginate(:per_page => 10, :page => params[:page], :order => 'created_at DESC')
  end
end
