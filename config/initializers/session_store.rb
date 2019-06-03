# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
BulletForge::Application.config.session = {
  :key         => '_danmaku_site_session',
  :secret      => '17d53009529425c20111bf38b0b9558329149e2d78f3989993395a1d85bf7322fd3368b596ee26cb4db107cf49b94e7bb6248b0e94540c4dfc930d1b7292b62f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
