class Version < ActiveRecord::Base
  belongs_to :project
  has_one :user, :through => :project
  
  validates_presence_of :version_number
  validates_uniqueness_of :version_number, :case_sensitive => false, :scope => :project_id, :message => "is already in use as a version number for this project"
  validates_attachment_presence :script_bundle
  error_messages_for :version, :header_message => "Custom message one", :message => "Custom message two"
  
  has_attached_file :script_bundle
  has_permalink :version_number, :update => true, :unique => false
  
  def to_param
    permalink
  end
end
