class User < ActiveRecord::Base
  has_many :projects
  has_many :versions, :through => :projects
  has_many :authored_comments, :class_name => "Comment", :foreign_key => "author_id"
  has_many :comments, :as => :commentable
  
  acts_as_authentic do |config|
    config.merge_validates_format_of_email_field_options :message => "At least try to make the email look like a real one."
    config.merge_validates_length_of_email_field_options :message => "That email has a pretty messed up length."
    config.merge_validates_uniqueness_of_email_field_options :message => "That email is registered already."
    config.merge_validates_format_of_login_field_options :message => "Your login can only use .-_@. And letters and numbers of course."
    config.merge_validates_length_of_login_field_options :message => "That login is either way too short or waaaaaaaaaay too long."
    config.merge_validates_uniqueness_of_login_field_options :message => "That login is taken already. And don't bother with different cases or symbols."
    config.merge_validates_confirmation_of_password_field_options :message => "You officially fail at password confirmation."
    config.merge_validates_length_of_password_confirmation_field_options :message => "The password confirmation seems kinda short."
    config.merge_validates_length_of_password_field_options :message => "Short password is short. You can do better than that."
  end
  acts_as_voter
  has_permalink :login, :update => true, :unique => true
  
  def is_owner_of(ownable)
    return false if ownable.class != Project && ownable.class != Version
    ownable.user == self
  end
  
  def can_destroy(comment)
    return false if comment.class != Comment
    self == comment.author || self == comment.commentable || is_owner_of(comment.commentable)
  end
  
  def to_param
    permalink
  end
end
