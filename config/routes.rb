# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

def secure_compare(str_a, str_b)
  ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(str_a),
    ::Digest::SHA256.hexdigest(str_b)
  )
end

BulletForge::Application.routes.draw do
  if ENV['SIDEKIQ_USERNAME'].present? && ENV['SIDEKIQ_PASSWORD'].present?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      secure_compare(username, ENV['SIDEKIQ_USERNAME']) &
        secure_compare(password, ENV['SIDEKIQ_PASSWORD'])
    end
  end

  mount Sidekiq::Web, at: '/sidekiq'

  resources :users, path: 'u' do
    resources :projects, path: 'p' do
      resource :archive, only: %i[show destroy]
      get '/v(/:id(/archive))' => 'versions#redirect' # legacy routing
    end
  end

  get '/u/:id/delete' => 'users#delete', :as => :user_delete

  resource :user_session
  resource :sitemap, only: [:show]
  resources :projects, only: [:index]

  get '/login' => 'user_sessions#new', :as => :login
  get '/logout' => 'user_sessions#destroy', :as => :logout
  get '/search' => 'search#advanced_search', :as => :search

  root to: 'home#show'
  match '/:controller(/:action(/:id))', via: %i[get post]
end
