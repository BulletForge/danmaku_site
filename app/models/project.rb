class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many   :versions, :dependent => :destroy
  has_many   :comments, :through => :versions
  has_many   :images,   :as => :attachable, :dependent => :destroy

  validates_presence_of :title, :message => "Nameless project, eh?"

  acts_as_taggable_on :tags
  
  has_permalink :title, :update => true, :unique => false
  validates_exclusion_of :permalink, :in => ["new"], :message => "Stop trying to mess with the website. Who names their projects new anyway?"
  validates_uniqueness_of :permalink, :scope => :user_id, :message => "You're using that title for another project already, remember?"

  def to_param
    permalink
  end

  def download_count
    downloads = 0
    versions.each do |version|
      downloads += version.download_count
    end
    downloads
  end

  def total_combined_votes
    count = 0
    versions.each do |v|
      count += v.combined_votes
    end
    count
  end

  def total_votes_count
    count = 0
    versions.each do |v|
      count += v.votes_count
    end
    count
  end
end
