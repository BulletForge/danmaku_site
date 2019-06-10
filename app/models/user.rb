class User < ActiveRecord::Base
  has_many :projects, :dependent => :destroy

  acts_as_authentic do |config|
    config.merge_validates_format_of_email_field_options :message => "Email must look like an email."
    config.merge_validates_length_of_email_field_options :message => "Email is too short."
    config.merge_validates_uniqueness_of_email_field_options :message => "Email is in use by another account."
    config.merge_validates_format_of_login_field_options :message => "Username can only use .-_@ as symbols."
    config.merge_validates_length_of_login_field_options :message => "Username must be between 3 and 100 characters long."
    config.validate_login_field false
    config.merge_validates_confirmation_of_password_field_options :message => "Password does not match."
    config.merge_validates_length_of_password_confirmation_field_options :message => "Password confirmation is too short."
    config.merge_validates_length_of_password_field_options :message => "Password is too short."
  end

  has_permalink :login, :update => false, :unique => false
  validates_exclusion_of :permalink, :in => ["new"], :message => "Username cannot be 'new'."
  validates_uniqueness_of :permalink, :message => "Username is in use by another account."
  validate :login_excludes_new_by_permalink, :login_is_unique_by_permalink

  before_save :check_suspicious

  def login_excludes_new_by_permalink
    errors.add(:login, "Username cannot be named 'new'.") if
      permalink == "new"
  end

  def login_is_unique_by_permalink
    user_with_permalink = User.find_by_permalink(permalink)
    errors.add(:login, "Username is in use by another account.") if
      user_with_permalink && user_with_permalink != self
  end

  def check_suspicious
    self.suspicious = true if email.include?("trbvn.com")
  end

  def roles
    admin? ? [:admin, :user] : [:user]
  end

  def owner_of?(ownable)
    return false if ownable.class != Project
    ownable.user == self
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
