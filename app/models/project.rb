class Project < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title
  acts_as_taggable_on :tags
end
