class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :danmakufu_version
  has_many   :versions, :dependent => :destroy
  has_many   :images,   :as => :attachable, :dependent => :destroy

  accepts_nested_attributes_for :versions
  accepts_nested_attributes_for :images, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  acts_as_taggable_on :tags
  has_permalink :title, :update => true, :unique => false

  validates_presence_of :title, :message => "Title is required."
  validate :title_excludes_new_by_permalink, :title_is_unique_by_permalink

  after_update :update_latest_version_updated_at

  def title_excludes_new_by_permalink
    errors.add(:title, "Title cannot be named 'new'") if
      permalink == "new"
  end

  def title_is_unique_by_permalink
    project_with_permalink = user.projects.find_by_permalink(permalink)
    errors.add(:title, "Title is already in use by another project you own.") if
      project_with_permalink && project_with_permalink != self
  end

  def to_param
    permalink
  end

  def calculate_download_count
    versions.inject(0) {|c, v| c += v.download_count }
  end

  def latest_version
    sorted_versions = versions.sort {|v1, v2| v1.updated_at <=> v2.updated_at }
    sorted_versions.first
  end

  def self.featured
    Project.where(:unlisted => false).order("created_at DESC").limit(100).max do |p1, p2|
      p1.downloads <=> p2.downloads
    end
  end

  def self.most_downloaded
    Project.where(:unlisted => false).order('downloads DESC').limit(5)
  end

  def self.latest
    Project.where(:unlisted => false).order('created_at DESC').limit(5)
  end

  private

  def update_latest_version_updated_at
    # update_all does not trigger callbacks.
    Version.where(:id => latest_version.id).update_all(:updated_at => updated_at)
  end
end
