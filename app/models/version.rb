class Version < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  validates_presence_of :version_number
  
  has_attached_file :script_bundle
  has_permalink :version_number, :update => true
  
  def to_param
    permalink
  end
end
