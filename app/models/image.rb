class Image < Asset
  validates :attachment, file_content_type: {
    allow: ["image/jpg", "image/jpeg", "image/png"],
    if: -> { attachment.attached? },
  }

  def s3_key
    "images/#{id}/original#{File.extname(attachment_file_name)}"
  end
end
