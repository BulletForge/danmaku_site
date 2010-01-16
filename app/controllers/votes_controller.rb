class VotesController < ApplicationController
  inherit_resources
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
  
  create!  &common_json_response
  update!  &common_json_response
  destroy! &common_json_response

  private
  
  def common_json_response
    @common_json_response ||= lambda { |success, failure|
      success.json { render :json => success_json }
      failure.json { render :json => failure_json }      
    }
  end
  
  def success_json
    @project.reload
    @version.reload
    { 
      :success => true, 
      :count => {
        :up => @version.votes_for, 
        :down => @version.votes_against
      }, 
      :total_count => {
        :up => @project.win_votes, 
        :down => @project.fail_votes
      }
    }.to_json
  end
  
  def failure_json
    { :success => false, :errors => @archive.errors }.to_json
  end

  def build_resource
    @archive ||= Archive.new(params[:vote], :votable => @version, :voter => current_user)
  end
  
end