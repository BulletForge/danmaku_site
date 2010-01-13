class Version < ActiveRecord::Base
  belongs_to :project
  has_one    :user, :through => :project
  has_one    :asset, :as => :attachable, :dependent => :destroy
  has_many   :comments, :as => :commentable, :dependent => :destroy
  
  validates_presence_of :version_number, :message => "What's the point of versioning without version numbers?"

  acts_as_voteable

  has_permalink :version_number, :update => true, :unique => false
  validates_exclusion_of :permalink, :in => ["new"], :message => "Version number new. That makes no sense."
  validates_uniqueness_of :permalink, :scope => :project_id, :message => "This project is already using that version number. Or not, but try something else anyway."
  
  def to_param
    permalink
  end

  def combined_votes
    votes_for - votes_against
  end
end
