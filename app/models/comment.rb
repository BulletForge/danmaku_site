class Comment < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  belongs_to :commentable, :polymorphic => true
  
  validates_presence_of :content, :message => "You must input some content for your comment."
end
