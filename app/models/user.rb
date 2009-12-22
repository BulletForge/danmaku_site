class User < ActiveRecord::Base
  has_many :projects
  has_many :versions, :through => :projects
  has_many :authored_comments, :class_name => "Comment", :foreign_key => "author_id"
  has_many :comments, :as => :commentable
  
  acts_as_authentic
  has_permalink :login, :update => true, :unique => true
  
  def is_owner_of(ownable)
    return false if ownable.class != Project && ownable.class != Version
    ownable.user == self
  end
  
  def can_destroy(comment)
    self == comment.author || self == comment.commentable || self.is_owner_of(comment.commentable)
  end
  
  def to_param
    permalink
  end
end
