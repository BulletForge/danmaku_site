if Rails.env.production?
  BulletForge.mailgun_api_key = ENV['MAILGUN_API_KEY']
  BulletForge.mailgun_domain  = ENV['MAILGUN_DOMAIN']
else
  config = YAML.load_file("#{Rails.root}/config/mailgun.yml")[Rails.env.to_s]
  BulletForge.mailgun_api_key = config['api_key']
  BulletForge.mailgun_domain  = config['domain']
end