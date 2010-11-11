class Archive < Asset
  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => {:access_key_id => BulletForge.s3_key, :secret_access_key => BulletForge.s3_secret},
    :path => 'system/:id/:filename',
    :bucket => BulletForge.s3_bucket
  MAX_FILE_SIZE = '300 MB'
end
