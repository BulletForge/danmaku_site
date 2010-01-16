ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'projects', :action => 'index'

  map.login  '/login',  :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'

  map.resources :users, :as => 'u' do |users|
    users.resources :comments, :only => [:index, :create, :destroy]
    users.resources :projects, :as => 'p' do |projects|
      projects.resources :versions, { :as => 'v', :member => {:download => :get, :vote_up => :get, :vote_down => :get, :upload => :post} } do |versions|
        versions.resources :comments, :only => [:index, :create, :destroy]
        versions.resource :archive, :only => [:show, :create]
        versions.resources :votes
      end
    end
  end
  map.resource  :user_session
  map.resources :projects, :only => :index

  # Default routes
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
