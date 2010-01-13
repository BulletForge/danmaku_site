ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'projects', :action => 'index'

  map.login  '/login',  :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'

  map.resources :users, :as => 'u' do |users|
    users.resources :comments, :only => [:index, :create, :destroy]
    users.resources :projects, :as => 'p' do |projects|
      projects.download '/v/:id/download', :controller => 'versions', :action => 'download'
      projects.vote_up '/v/:id/vote_up', :controller => 'versions', :action => 'vote_up'
      projects.vote_down '/v/:id/vote_down', :controller => 'versions', :action => 'vote_down'
      projects.upload_script '/v/:id/upload-script', :controller => 'versions', :action => 'upload_script_bundle'
      projects.upload '/v/:id/upload', :controller => 'versions', :action => 'upload'
      projects.resources :versions, :as => 'v' do |versions|
        versions.resources :comments, :only => [:index, :create, :destroy]
      end
    end
  end
  map.resource  :user_session
  map.resources :projects, :only => :index

  # Default routes
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
