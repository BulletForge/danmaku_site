class VotesController < ApplicationController
  inherit_resources
  respond_to :json
  actions :create, :update, :destroy
  belongs_to :user, :finder => :find_by_permalink! do
    belongs_to :project, :finder => :find_by_permalink! do
      belongs_to :version, :finder => :find_by_permalink!
    end
  end
  
  # preload all resource / collection in before filter
  before_filter :collection, :only =>[:index]
  before_filter :resource, :only => [:show, :edit, :update, :destroy]
  before_filter :build_resource, :only => [:new, :create, :index]
  filter_access_to :all

  create! do |success, failure|
    success.json { render :json => success_json }
    failure.json { render :json => failure_json }
  end
  update! do |success, failure|
    success.json { render :json => success_json }
    failure.json { render :json => failure_json }
  end
  destroy! do |success, failure|
    success.json { render :json => success_json }
    failure.json { render :json => failure_json }
  end

  private
  
  def success_json
    @project.reload
    @version.reload
    str = render_to_string :template => 'versions/_votes.html.erb', :locals => { :user => @user, :project => @project, :version => @version }
    { 
      :success => true,
      :replace_dom => '#votes',
      :partial => str
    }.to_json
  end
  
  def failure_json
    { :success => false, :errors => @vote.errors }.to_json
  end

  def build_resource
    @user = User.find_by_permalink!(params[:user_id])
    @project = @user.projects.find_by_permalink!(params[:project_id])
    @version = @project.versions.find_by_permalink!(params[:version_id])
    @vote = Vote.new(:vote => params[:vote][:vote], :voteable => @version, :voter => current_user)
  end
  
end