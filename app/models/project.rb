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
