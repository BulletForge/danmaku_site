class User < ActiveRecord::Base
  has_many :projects
  
  acts_as_authentic
  has_permalink :login, :update => true, :unique => true
  
  def is_owner_of(ownable)
    ownable.user == self
  end
  
  def to_param
    permalink
  end
end
