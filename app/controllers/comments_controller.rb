class CommentsController < ApplicationController
  inherit_resources
  actions :index, :create, :update, :destroy
  belongs_to :user, :finder => :find_by_permalink!, :polymorphic => true
  belongs_to :version, :finder => :find_by_permalink!, :polymorphic => true
  
  # preload all resource / collection in before filter
  before_filter :collection, :only =>[:index]
  before_filter :resource, :only => [:show, :edit, :update, :destroy]
  before_filter :build_resource, :only => [:new, :create, :index]
  filter_access_to :all
  
  create! do |success, failure|
    success.html { redirect_to parent_url }
  end
  
  destroy! do |success, failure|
    success.html { redirect_to parent_url }
  end
  
  protected
  
  def build_resource
    @comment ||= end_of_association_chain.send(method_for_build, params[resource_instance_name] || {})
    @comment.commentable = parent
    @comment
  end
end
