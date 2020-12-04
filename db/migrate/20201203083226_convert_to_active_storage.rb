class ConvertToActiveStorage < ActiveRecord::Migration[6.0]
  require 'open-uri'

  def up


    Rails.application.eager_load!

    transaction do
      Image.find_each do |image|
        ext = File.extname(image.attachment_file_name)
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

      Archive.find_each do |archive|
        path = Rails.root.join('storage', archive.s3_key)
        next unless File.exists?(path)

        md5 = Digest::MD5.base64digest(File.read(path))

        say "inserting blob for archive #{archive.id}"

        result = ActiveRecord::Base.connection.raw_connection.exec_prepared(
          'active_storage_blob_statement', [
            Archive.generate_unique_secure_token,
            archive.attachment_file_name,
            archive.attachment_content_type,
            archive.attachment_file_size,
            md5,
            archive.updated_at.iso8601
          ]
        )

        say "inserting attachement for archive #{archive.id}"
        ActiveRecord::Base.connection.raw_connection.exec_prepared(
          'active_storage_attachment_statement', [
            'attachment',
            archive.class.name,
            archive.id,
            result.values.last.last,
            archive.updated_at.iso8601,
          ]
        )
      end
    end
  end

  def down
    transaction do
      execute "TRUNCATE TABLE active_storage_blobs RESTART IDENTITY CASCADE"
      execute "TRUNCATE TABLE active_storage_attachments RESTART IDENTITY CASCADE"
    end
  end
end
