namespace :heroku do
  desc "Uploads files to S3 in preparation for Heroku usage"
  task :upload_files_to_s3 => :environment do
    puts 'Generating S3 keys...'
    Archive.each do |archive|
      archive.s3_key = 'archives/#{archive.version.id.to_s}/#{archive.attachment_file_name}'
    end
    
    puts 'Grabbing S3 credentials'
    filename = "#{Rails.root}/config/amazon_s3.yml"
    s3_info = YAML.load(File.open(filename))['production']
    
    s3_access_key    = s3_info['access_key_id']
    s3_access_secret = s3_info['secret_access_key']
    s3_bucket        = s3_info['bucket']
    
    puts 'Connecting to S3...'
    AWS::S3::Base.establish_connection!(
      :access_key_id     => s3_access_key
      :secret_access_key => s3_access_secret
    )
    
    puts 'Uploading archives to S3...'
    Archive.each do |archive|
      key = archive.s3_key
      file = archive.url
      AWS::S3::S3Object.store key, open(file), s3_bucket
    end
    
    puts 'Uploading images to S3...'
    Images.each do |image|
      key_prefix = 'images/#{image.id}/'
      ext = File.extname i.attachment.path
      AWS::S3::S3Object.store key_prefix+'original.#{ext}', image.url, s3_bucket
      AWS::S3::S3Object.store key_prefix+'normal.#{ext}', image.url(:normal), s3_bucket
      AWS::S3::S3Object.store key_prefix+'thumb.#{ext}', image.url(:thumb), s3_bucket
    end
    
    puts 'All files uploaded! Run "heroku db:push postgres://username:password@localhost/bulletforge --app bulletforge"'+
      'to push the database to Heroku'
  end
end