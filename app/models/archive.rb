class Archive < Asset
  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => '/home/deploy/s3.yml',
    :path => 'system/:id/:archive_file_name.:extension',
    :bucket => 'bulletforge_bucket'
  MAX_FILE_SIZE = '300 MB'
end
