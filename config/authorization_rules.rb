authorization do
  role :admin do
    # admin can do everything
    has_permission_on [:users, :projects, :versions, :comments, :votes, :archives], :to => [:index, :show, :new, :create, :edit, :update, :destroy]

    # admin can logout, but cannot login (because they are already logged in)
    has_permission_on :user_sessions, :to => [:destroy]
  end
  
  role :guest do
    # guests can view users, projects, versions, comments, votes, and archives
    has_permission_on [:users, :projects, :versions, :comments, :votes, :archives], :to => [:index, :show]

    # guests can login
    has_permission_on :user_sessions, :to => [:new, :create]
    
    # guests can create new new user accounts
    has_permission_on :users, :to => [:new, :create]
  end
  
  role :user do
    # user can view everything guests can
    has_permission_on [:users, :projects, :versions, :comments, :votes, :archives], :to => [:index, :show]
    
    # user can logout, but cannot login (because they are already logged in)
    has_permission_on :user_sessions, :to => [:destroy]    
    
    # users can create new projects, versions, comments, votes, and archives
    has_permission_on [:projects, :versions, :comments, :votes, :archives], :to => [:new, :create] do
      if_attribute :user => is { user }
    end
    
    # users can edit and destroy their own user profile
    has_permission_on :user, :to => [:edit, :update, :destroy] do
      if_attribute :id => is { user.id }
    end
    
    # users can edit and destroy projects, versions, comments, votes, and archives
    has_permission_on [:projects, :versions, :comments, :votes, :archives], :to => [:edit, :update, :destroy] do
      if_attribute :user => is { user }
    end
    
    # users can destroy comments if commentable's user is current_user 
    has_permission_on :comments, :to => [:destroy] do
      if_attribute :commentable => { :user => is { user } }
    end
    
  end
  

end
