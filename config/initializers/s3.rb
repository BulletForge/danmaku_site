if Rails.env.production? 
  BulletForge.s3_key = ENV['S3_KEY']
  BulletForge.s3_secret = ENV['S3_SECRET']
  BulletForge.s3_bucket = ENV['S3_BUCKET']
else
  config = YAML.load_file("#{Rails.root}/config/s3.yml")[Rails.env.to_s]
  BulletForge.s3_key = config['key']
  BulletForge.s3_secret = config['secret']
  BulletForge.s3_bucket = config['bucket']
end