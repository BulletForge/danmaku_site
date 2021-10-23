class Asset < ApplicationRecord
  belongs_to :attachable, :polymorphic => true
  delegate :user, :to => :attachable

  def s3_file
    client = Aws::S3::Client.new(region: ENV['AWS_REGION'])
    rsp = client.get_object(bucket: ENV['AWS_BUCKET'], key: s3_key)
    rsp.body
  end
end
