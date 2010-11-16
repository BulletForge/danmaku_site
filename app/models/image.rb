class Image < Asset
  has_attached_file :attachment, 
    :styles => {
      :normal => "400x300>",
      :thumb => "160x120>"
    },
    :storage => :s3,
    :s3_credentials => {
      :access_key_id     => S3SwfUpload::S3Config.access_key_id,
      :secret_access_key => S3SwfUpload::S3Config.secret_access_key,
      :bucket => S3SwfUpload::S3Config.bucket
    },
    :path => "/images/:id/:style.:extension"
end
