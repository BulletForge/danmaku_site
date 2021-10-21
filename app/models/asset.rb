class Asset < ApplicationRecord
  belongs_to :attachable, :polymorphic => true
  delegate :user, :to => :attachable

  has_one_attached :attachment, dependent: :purge_later

  def s3_file
    client = Aws::S3::Client.new(region: ENV['AWS_REGION'])
    rsp = client.get_object(bucket: ENV['AWS_BUCKET'], key: s3_key)
    rsp.body
  end

  def migrate_to_active_storage
    attachment.attach(
      io: s3_file,
      filename: attachment_file_name,
      content_type: attachment_content_type
    )
  end
end
