class Version < ActiveRecord::Base
  belongs_to :project
  has_one    :user, :through => :project
  has_one    :archive, :as => :attachable, :dependent => :destroy
  has_many   :comments, :as => :commentable, :dependent => :destroy
  
  validates_presence_of :version_number, :message => "Version number is required."

  acts_as_voteable

  has_permalink :version_number, :update => true, :unique => false
  validates_exclusion_of :permalink, :in => ["new"], :message => "Version number cannot be 'new'."
  validates_uniqueness_of :permalink, :scope => :project_id, :message => "Version number is too similar to another number this project is using."
  
  def to_param
    permalink
  end
  
  def increment_download_counter!
    Version.transaction do
      update_attributes(:download_count => self.download_count += 1)
      update_project_download_counter_cache
    end
  end
  
  private
  def update_project_download_counter_cache
    project.update_attributes!(:downloads => project.calculate_download_count)
  end
  
end
