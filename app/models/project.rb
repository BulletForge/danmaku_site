class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many   :versions, :dependent => :destroy
  has_many   :comments, :through => :versions
  has_many   :images,   :as => :attachable, :dependent => :destroy

  accepts_nested_attributes_for :versions
  accepts_nested_attributes_for :images, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  acts_as_taggable_on :tags
  has_permalink :title, :update => true, :unique => false
  
  validates_presence_of :title, :message => "Title is required."
  validates_exclusion_of :permalink, :in => ["new"], :message => "Title cannot be named 'new'."
  validates_uniqueness_of :permalink, :scope => :user_id, :message => "Title is too similar to an existing project you have made."

  def to_param
    permalink
  end

  def calculate_download_count
    versions.inject(0) {|c, v| c += v.download_count }
  end

  def calculate_win_votes
    versions.inject(0) { |c, v| c += v.votes_for }
  end

  def calculate_fail_votes
    versions.inject(0) { |c, v| c += v.votes_against }
  end
end
