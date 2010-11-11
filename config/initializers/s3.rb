if Rails.env.production? 
  Bulletforge.s3_key = ENV['S3_KEY']
  Bulletforge.s3_secret = ENV['S3_SECRET']
  Bulletforge.s3_bucket = ENV['S3_BUCKET']
else
  config = YAML.load_file("#{Rails.root}/config/s3.yml")[Rails.env.to_s]
  Bulletforge.s3_key = config['key']
  Bulletforge.s3_secret = config['secret']
  Bulletforge.s3_bucket = config['bucket']
end