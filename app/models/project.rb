class Project < ActiveRecord::Base
  belongs_to :user
  has_many   :versions

  validates_presence_of :title

  acts_as_taggable_on :tags
  has_permalink :title, :update => true
  
  def to_param
    permalink
  end
end
