class Version < ActiveRecord::Base
  belongs_to :project
  has_one    :user, :through => :project
  has_many   :comments, :as => :commentable
  
  validates_presence_of :version_number, :message => "You must input a version number."
  validates_uniqueness_of :version_number, :case_sensitive => false, :scope => :project_id, :message => "You are already using that version number for this project."
  validates_attachment_presence :script_bundle, :message => "You must attach a file."
  
  has_attached_file :script_bundle
  has_permalink :version_number, :update => true, :unique => false
  
  def to_param
    permalink
  end
end
