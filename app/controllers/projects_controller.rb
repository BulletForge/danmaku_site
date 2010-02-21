class ProjectsController < ApplicationController
  inherit_resources
  include PermalinkResources
  belongs_to :user, :finder => :find_by_permalink!, :optional => true  

  # preload all resource / collection in before filter
  before_filter :collection, :only =>[:index]
  before_filter :resource, :only => [:show, :edit, :update, :destroy]
  before_filter :build_resource, :only => [:new, :create, :index]
  filter_access_to :all
  
  # Change redirect
  destroy! do |success, failure|
    success.html {redirect_to user_path(@user)}
  end

  def new
    @project.versions.build
    new!
  end

  def show
    version = @project.versions.last
    redirect_to user_project_version_path(@user, @project, version)
  end


  private
  # Paginate the projects collection  
  def _collection
    @search ||= end_of_association_chain.search( params[:search] )
    @search.paginate( :per_page => 10, :page => params[:page] )
  end
end
