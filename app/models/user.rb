class User < ActiveRecord::Base
  has_many :projects
  has_many :versions, :through => :projects
  has_many :authored_comments, :class_name => "Comment", :foreign_key => "author_id"
  has_many :comments, :as => :commentable
  
  acts_as_authentic do |config|
    config.merge_validates_format_of_email_field_options :message => "Email must look like an email."
    config.merge_validates_length_of_email_field_options :message => "Email is too short."
    config.merge_validates_uniqueness_of_email_field_options :message => "Email is in use by another account."
    config.merge_validates_format_of_login_field_options :message => "Username can only use .-_@ as symbols."
    config.merge_validates_length_of_login_field_options :message => "Username is too short or too long."
    config.validate_login_field false
    config.merge_validates_confirmation_of_password_field_options :message => "Password does not match."
    config.merge_validates_length_of_password_confirmation_field_options :message => "Password confirmation is too short."
    config.merge_validates_length_of_password_field_options :message => "Password is too short."
  end
  acts_as_voter

  has_permalink :login, :update => true, :unique => false
  validates_exclusion_of :permalink, :in => ["new"], :message => "Username cannot be 'new'."
  validates_uniqueness_of :permalink, :message => "Username is in use by another account."
  
  # for declarative_authorization integration
  def role_symbols
    admin? ? [:admin] : [:user] 
  end
  
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
