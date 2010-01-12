class Version < ActiveRecord::Base
  belongs_to :project
  has_one    :user, :through => :project
  has_one    :asset, :as => :attachable
  has_many   :comments, :as => :commentable
  
  validates_presence_of :version_number, :message => "What's the point of versioning without version numbers?"
  validates_uniqueness_of :version_number, :case_sensitive => false, :scope => :project_id, :message => "This project is already using that version number. Or not, but try something else anyway."
  validates_presence_of :asset_id, :message => "Attach a file!"
  
  acts_as_voteable
  has_permalink :version_number, :update => true, :unique => false
  
  def to_param
    permalink
  end

  def combined_votes
    votes_for - votes_against
  end
end
