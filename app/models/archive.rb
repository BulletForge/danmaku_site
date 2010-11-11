class Archive < Asset
  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => '/Users/abner/s3.yml',
    :path => 'system/:id/:filename',
    :bucket => 'bulletforge_bucket'
  MAX_FILE_SIZE = '300 MB'
end
