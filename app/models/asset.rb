class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  
  delegate :user, :to => :attachable
end
