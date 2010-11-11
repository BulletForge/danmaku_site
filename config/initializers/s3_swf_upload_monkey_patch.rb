module S3SwfUpload
  class S3Config
    def self.load_config
      if Rails.env.production?
        @@access_key_id = ENV['S3_KEY']
        @@secret_access_key = ENV['S3_SECRET']
        @@bucket = ENV['S3_BUCKET']
        @@max_file_size = ENV['S3_MAX_FILE_SIZE']
        @@acl = ENV['S3_ACL'] || 'private'
      else
        begin
          filename = "#{Rails.root}/config/amazon_s3.yml"
          file = File.open(filename)
          config = YAML.load(file)[Rails.env]

          if config == nil
            raise "Could not load config options for #{Rails.env} from #{filename}."
          end

          @@access_key_id = config['access_key_id']
          @@secret_access_key = config['secret_access_key']
          @@bucket = config['bucket']
          @@max_file_size = config['max_file_size']
          @@acl = config['acl'] || 'private'



          unless @@access_key_id && @@secret_access_key && @@bucket
            raise "Please configure your S3 settings in #{filename} before continuing so that S3 SWF Upload can function properly."
          end
        rescue Errno::ENOENT
           # No config file yet. Not a big deal. Just issue a warning
           puts "WARNING: You are using the S3 SWF Uploader gem, which wants a config file at #{filename}, " +
              "but none could be found. You should try running 'rails generate s3_swf_upload:uploader'"
        end
      end
    end
  end
end