class Archive < Asset
  before_destroy :destroy_s3_data

  MAX_FILE_SIZE = '300 MB'.freeze

  def import_s3_data
    self.attachment_content_type = s3_archive.content_type
    self.attachment_file_size = s3_archive.content_length
    self.attachment_updated_at = s3_archive.last_modified
  end

  def attachment_url
    s3_archive.public_url
  end

  def destroy_s3_data
    s3_archive.delete if s3_archive.exists?
  end
end
