class Archive < Asset
  AWS::S3::Base.establish_connection!(
    :access_key_id     => S3SwfUpload::S3Config.access_key_id,
    :secret_access_key => S3SwfUpload::S3Config.secret_access_key
  )

  before_destroy :destroy_s3_data
  MAX_FILE_SIZE = '300 MB'

  def import_s3_data
    s3_archive = find_s3_archive
    s3_data = s3_archive.about

    self.attachment_content_type = s3_data["content-type"]
    self.attachment_file_size = s3_data["content-length"].to_i
    self.attachment_updated_at = s3_data["last-modified"]
  end

  def attachment_url
    s3_archive = find_s3_archive
    s3_archive.url
  end

  def destroy_s3_data
    return unless AWS::S3::S3Object.exists? s3_key, S3SwfUpload::S3Config.bucket

    s3_archive = find_s3_archive
    s3_archive.delete

    if AWS::S3::S3Object.exists? s3_key, S3SwfUpload::S3Config.bucket
      errors.add(:base, "S3 data not destroyed")
      false
    end
  end

  private

  def find_s3_archive
    AWS::S3::S3Object.find s3_key, S3SwfUpload::S3Config.bucket
  end
end
