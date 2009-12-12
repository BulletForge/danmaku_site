class Project < ActiveRecord::Base
  validates_presence_of :title

  acts_as_taggable_on :tags
end
