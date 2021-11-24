class Project < ApplicationRecord
  SCRIPT_ARCHIVE_CONTENT_TYPES = %w[
    application/zip
    application/x-rar-compressed
    application/x-7z-compressed
    application/gzip
    application/x-tar
    application/x-bzip2
    application/x-gtar
  ].freeze

  COVER_IMAGE_CONTENT_TYPES = %w[
    image/webp
    image/jpeg
    image/png
    image/gif
  ].freeze

  belongs_to :user, counter_cache: true
  belongs_to :category
  belongs_to :danmakufu_version

  acts_as_taggable_on :tags
  has_permalink :title, update: true, unique: false

  validates_presence_of :title, message: 'Title is required.'
  validate :title_excludes_new_by_permalink, :title_is_unique_by_permalink

  #
  # ActiveStorage Attachments
  #
  has_one_attached :script_archive, dependent: :purge_later
  has_many_attached :cover_images, dependent: :purge_later

  validates :script_archive, attached: true, content_type: SCRIPT_ARCHIVE_CONTENT_TYPES
  validates :cover_images, attached: true, content_type: COVER_IMAGE_CONTENT_TYPES

  #
  # Methods
  #
  def title_excludes_new_by_permalink
    errors.add(:title, "Title cannot be named 'new'") if
      permalink == 'new'
  end

  def title_is_unique_by_permalink
    project_with_permalink = user.projects.find_by_permalink(permalink)
    errors.add(:title, 'Title is already in use by another project you own.') if
      project_with_permalink && project_with_permalink != self
  end

  def to_param
    permalink
  end

  def increment_download_counter!
    Project.where(id: id).update_all(downloads: self.downloads += 1)
  end

  def takedown(reason)
    Project.where(id: id).update_all(soft_deleted: true, deleted_reason: reason)
    cover_images.purge_later
    script_archive.purge_later
  end

  def self.featured
    publically_viewable.order('created_at DESC').limit(100).max do |p1, p2|
      p1.downloads <=> p2.downloads
    end
  end

  def self.publically_viewable
    where(unlisted: false, soft_deleted: false)
  end

  def self.most_downloaded
    publically_viewable.order('downloads DESC').limit(5)
  end

  def self.latest
    publically_viewable.order('created_at DESC').limit(5)
  end
end
