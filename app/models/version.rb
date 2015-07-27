class Version < ActiveRecord::Base
  belongs_to :project
  has_one    :user, :through => :project
  has_one    :archive, :as => :attachable, :dependent => :destroy

  validates_presence_of :version_number, :message => "Version number is required."
  validate :version_number_excludes_new_by_permalink, :version_number_is_unique_by_permalink

  acts_as_voteable
  has_permalink :version_number, :update => true, :unique => false

  after_update :update_project_updated_at

  def version_number_excludes_new_by_permalink
    errors.add(:version_number, "Version number cannot be named 'new'") if
      permalink == "new"
  end

  def version_number_is_unique_by_permalink
    unless self.new_record?
      version_with_permalink = project.versions.find_by_permalink(permalink)
      errors.add(:title, "Version number is already in use by the same project.") if
        version_with_permalink && version_with_permalink != self
    end
  end

  def to_param
    permalink
  end

  def increment_download_counter!
    Version.transaction do
      Version.where(:id => id).update_all(:download_count => self.download_count += 1)
      update_project_download_counter_cache
    end
  end

  def latest_version?
    self == project.latest_version
  end

  private

  def update_project_download_counter_cache
    Project.where(:id => project.id).update_all(:downloads => project.calculate_download_count)
  end

  def update_project_updated_at
    # update_all does not trigger callbacks.
    Project.where(:id => project.id).update_all(:updated_at => updated_at) if latest_version?
  end
end
