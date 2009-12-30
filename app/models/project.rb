class Project < ActiveRecord::Base
  belongs_to :user
  has_many   :versions
  has_many   :comments, :through => :versions

  validates_presence_of :title, :message => "Nameless project, eh?"
  validates_uniqueness_of :title, :case_sensitive => false, :scope => :user_id, :message => "You're using that title for another project already, remember?"

  acts_as_taggable_on :tags
  has_permalink :title, :update => true, :unique => false
  
  def to_param
    permalink
  end
end
