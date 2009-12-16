class User < ActiveRecord::Base
  acts_as_authentic
  has_many :projects
  
  def is_owner_of(ownable)
    return true if ownable.user == self
    return false
  end
end
