BulletForge::Application.routes.draw do

  resources :users, :as => 'u' do
    resources :comments, :only => [:index, :create, :destroy]
    resources :projects, :as => 'p' do
      resources :versions, :as => 'v' do
        member do
          get :download
          get :upload
          get :vote_up
          get :vote_down
        end
        resources :comments, :only => [:index, :create, :destroy]
        resource :archive, :only => [:show]
        resources :votes
      end
    end
  end

  resource :user_session
  resource :sitemap, :only => [:show]
  resources :projects, :only => [:index]
  
  get '/login' => 'user_sessions#new', :as => :login
  get '/logout' => 'user_sessions#destroy', :as => :logout
  
  post '/upload/archive' => 'archives#create', :as => :upload_archive 
  post '/upload/image' => 'images#create', :as => :upload_image
  
  root :to => 'home#show'  
  match '/:controller(/:action(/:id))'
end
