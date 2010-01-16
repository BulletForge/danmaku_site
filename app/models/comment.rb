class Comment < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  belongs_to :commentable, :polymorphic => true
  validates_presence_of :content, :message => "Empty comment? Like I'm gonna let you post that."
  
  alias :user :author
end
