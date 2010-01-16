class User < ActiveRecord::Base
  has_many :projects
  has_many :versions, :through => :projects
  has_many :authored_comments, :class_name => "Comment", :foreign_key => "author_id"
  has_many :comments, :as => :commentable
  
  acts_as_authentic do |config|
    config.merge_validates_format_of_email_field_options :message => "At least try to make the email look like a real one."
    config.merge_validates_length_of_email_field_options :message => "That email has a pretty messed up length."
    config.merge_validates_uniqueness_of_email_field_options :message => "That email is registered already."
    config.merge_validates_format_of_login_field_options :message => "Your username can only use .-_@. And letters and numbers of course."
    config.merge_validates_length_of_login_field_options :message => "That username is either way too short or waaaaaaaaaay too long."
    config.validate_login_field false
    config.merge_validates_confirmation_of_password_field_options :message => "You officially fail at password confirmation."
    config.merge_validates_length_of_password_confirmation_field_options :message => "The password confirmation seems kinda short."
    config.merge_validates_length_of_password_field_options :message => "Short password is short. You can do better than that."
  end
  acts_as_voter

  has_permalink :login, :update => true, :unique => false
  validates_exclusion_of :permalink, :in => ["new"], :message => "Calling yourself new is kinda gonna mess up the website. Try something else for your username."
  validates_uniqueness_of :permalink, :message => "That username is taken already. And don't bother with different cases or symbols."
  
  def owner_of?(ownable)
    return false if ownable.class != Project && ownable.class != Version
    ownable.user == self
  end
  
  def can_destroy?(comment)
    return false if comment.class != Comment
    self == comment.author || self == comment.commentable || owner_of?(comment.commentable)
  end
  
  def to_param
    permalink
  end
  
  
  def self.current
    Thread.current[:current_user]
  end

  def self.current=(user)
    Thread.current[:current_user] = user
  end
  
  def current?
    self.class.current == self
  end
  
end
