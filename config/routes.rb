ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'projects', :action => 'index'

  map.login     '/login',  :controller => 'user_sessions', :action => 'new'
  map.logout    '/logout', :controller => 'user_sessions', :action => 'destroy'

  map.resources :users do |users|
    users.resources :projects
  end
  map.resource  :user_session
  map.resources :projects

  # Default routes
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
