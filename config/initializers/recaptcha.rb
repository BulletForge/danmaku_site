if Rails.env.production?
  BulletForge.recaptcha_site_key   = ENV['RECAPTCHA_SITE_KEY']
  BulletForge.recaptcha_secret_key = ENV['RECAPTCHA_SECRET_KEY']
else
  config = YAML.load_file("#{Rails.root}/config/recaptcha.yml")[Rails.env.to_s]
  BulletForge.recaptcha_site_key   = config['site_key']
  BulletForge.recaptcha_secret_key = config['secret_key']
end

Recaptcha.configure do |config|
  config.public_key  = BulletForge.recaptcha_site_key
  config.private_key = BulletForge.recaptcha_secret_key
  config.api_version = 'v2'
end
