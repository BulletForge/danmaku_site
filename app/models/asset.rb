class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true

  has_attached_file :attachment
  
  MAX_FILE_SIZE = '300 MB'
end
