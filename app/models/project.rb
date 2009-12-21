class Project < ActiveRecord::Base
  belongs_to :user
  has_many   :versions

  validates_presence_of :title, :message => "You must input a title for your project."
  validates_uniqueness_of :title, :case_sensitive => false, :scope => :user_id, :message => "You are already using that title for another of your projects."

  acts_as_taggable_on :tags
  has_permalink :title, :update => true, :unique => false
  
  def to_param
    permalink
  end
end
