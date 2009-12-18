class Project < ActiveRecord::Base
  belongs_to :user
  has_many   :versions

  validates_presence_of :title
  validates_uniqueness_of :title, :case_sensitive => false, :scope => :user_id, :message => "is already in use as a project title for this account"

  acts_as_taggable_on :tags
  has_permalink :title, :update => true, :unique => false
  
  def to_param
    permalink
  end
end
