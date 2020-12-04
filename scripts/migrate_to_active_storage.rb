#!bin/rails runner

INSERT_BLOB = ActiveRecord::Base.connection.raw_connection.prepare('active_storage_blob_statement', <<-SQL)
INSERT INTO active_storage_blobs (
  key, filename, content_type, metadata, byte_size, checksum, created_at
) VALUES ($1, $2, $3, '{}', $4, $5, $6) RETURNING id;
SQL

INSERT_ATTACHMENT = ActiveRecord::Base.connection.raw_connection.prepare('active_storage_attachment_statement', <<-SQL)
INSERT INTO active_storage_attachments (
  name, record_type, record_id, blob_id, created_at
) VALUES ($1, $2, $3, $4, $5)
SQL

class Migrator
  attr_reader :s3_client, :model

  def initialize(s3_client, model)
    @s3_client = s3_client
    @model = model
  end

  def call

  end

  private

  def file_name
    model.attachment_file_name
  end

  def content_type
    model.attachment_content_type
  end

  def file_size
    model.attachment_file_size
  end

  def updated_at
    model.updated_at.iso8601
  end

  def s3_key
    "model/#{model.id}/original#{File.extname(file_name)}"
  end

  def s3_obj
    bucket.objects[s3_key]
  end

end

Image.transaction do
  Image.find_each do |image|
    ext =
    path = Rails.root.join('storage', 'images', image.id.to_s, "original#{ext}")
    next unless File.exists?(path)

    md5 = Digest::MD5.base64digest(File.read(path))

    say "inserting blob for image #{image.id}"

    result = ActiveRecord::Base.connection.raw_connection.exec_prepared(
      'active_storage_blob_statement', [
        Image.generate_unique_secure_token,
        image.attachment_file_name,
        image.attachment_content_type,
        image.attachment_file_size,
        md5,
        image.updated_at.iso8601
      ]
    )

    say "inserting attachement for image #{image.id}"
    ActiveRecord::Base.connection.raw_connection.exec_prepared(
      'active_storage_attachment_statement', [
        'attachment',
        image.class.name,
        image.id,
        result.values.last.last,
        image.updated_at.iso8601,
      ]
    )
  end
end
