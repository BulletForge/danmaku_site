class Image < Asset
  VARIANTS = {
    normal: {
      resize_to_limit: [400, 300]
    },
    thumb: {
      resize_to_limit: [160, 120]
    }
  }

  has_one_attached :attachment

  has_attached_file :attachment,
    :styles => {
      :normal => "400x300>",
      :thumb => "160x120>"
    },
    :storage => :s3,
    :s3_credentials => {
      :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :bucket => ENV['AWS_BUCKET'],
      :s3_region => ENV['AWS_REGION']
    },
    :path => "/images/:id/:style.:extension",
    :default_url => "/images/:style/missing.png"

  def url(style=:normal)
    attachment.url(style).gsub("http://", "https://")
  end
end
