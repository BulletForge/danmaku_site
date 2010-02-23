class Comment < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  belongs_to :commentable, :polymorphic => true
  validates_presence_of :content, :message => "Comment cannot be empty."
  validates_length_of :content, :maximum => 500, :message => "Comment cannot exceed 500 characters."
  
  alias :user :author
end
