class ArchivesController < ApplicationController
  inherit_resources
  acts_as_singleton!
  actions :create, :show, :destroy
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
  
  show! do |format|
    @version.increment_download_counter!
    format.html { redirect_to @version.archive.attachment.url }
  end
  
  create! do |success, failure|
    
    success.json {
      str = render_to_string :template => 'versions/_archive.html.erb', :locals => { :user => @user, :project => @project, :version => @version }
      render :json => { 
        :success => true, 
        :replace_dom => '#archive', 
        :partial => str
      }.to_json
    }
    failure.json {render :json => { :success => false, :errors => @archive.errors }.to_json }
  end
  
  destroy! do |success, failure|
    success.json { render :json => { :success => true }.to_json}
    failure.json { render :json => { :success => false, :errors => @archive.errors }.to_json }
  end

  private

  def build_resource
    end_of_association_chain
    @archive ||= Archive.new(:attachment => swf_upload_data, :attachable => @version)
  end
end