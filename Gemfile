source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'
gem 'jbuilder', '~> 2.7'
gem 'image_processing', '~> 1.2'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'acts-as-taggable-on'
gem 'authlogic'
gem 'aws-sdk-s3', require: false
gem 'cancancan'
gem 'formtastic', '~> 2.0', require: 'formtastic'
gem 'haml-rails'
gem 'inherited_resources'
gem 'mini_magick'
gem 'permalink_fu'
gem 'recaptcha'
gem 'will_paginate'

# Apple Silicon fix
gem 'ffi', github: 'felipecsl/ffi', ref: '17dbdfc43d1f6db1cbd2ff14635ffa1a620380a6'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rubocop'
  gem 'dotenv-rails'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
  gem 'foreman'
  gem 'solargraph'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

