class Archive < Asset
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
  
  def find_s3_archive
    AWS::S3::Base.establish_connection!(
      :access_key_id     => S3SwfUpload::S3Config.access_key_id,
      :secret_access_key => S3SwfUpload::S3Config.secret_access_key
    )
    
    AWS::S3::S3Object.find s3_key, S3SwfUpload::S3Config.bucket
  end
end
