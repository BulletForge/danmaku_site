privileges do
  privilege :view do
    includes :index, :show
  end

  privilege :make do
    includes :new, :create
  end

  privilege :change do
    includes :edit, :update
  end

  privilege :manage do
    includes :edit, :update, :destroy
  end

  privilege :do_all do
    includes :index, :show, :new, :create, :edit, :update, :destroy
  end

end

authorization do
  role :admin do
    # admin can do everything
    has_permission_on [:users, :projects, :versions, :comments, :votes, :archives], :to => :do_all

    # admin can logout, but cannot login (because they are already logged in)
    has_permission_on :user_sessions, :to => :destroy
  end
  
  role :guest do
    # guests can view users, projects, versions, comments, votes, and archives
    has_permission_on [:users, :projects, :versions, :comments, :votes, :archives], :to => :view

    # guests can login
    has_permission_on :user_sessions, :to => :make
    
    # guests can create new user accounts
    has_permission_on :users, :to => :make
  end
  
  role :user do
    # user can view everything guests can
    has_permission_on [:users, :projects, :versions, :comments, :votes, :archives], :to => :view
    
    # user can logout, but cannot login (because they are already logged in)
    has_permission_on :user_sessions, :to => :destroy   
    
    # users can create, edit, and destroy their own projects, versions, comments, and archives
    has_permission_on [:projects, :versions, :comments, :archives], :to => :do_all do
      if_attribute :user => is { user }
    end

    # users can vote on versions as long as it isn't their own version
    has_permission_on :votes, :to => :create do
      if_attribute :voteable => { :user => is_not { user } }
    end
    
    # users can edit their own user profile
    has_permission_on :users, :to => :change do
      if_attribute :id => is { user.id }
    end
    
    # users can destroy comments if commentable's user is current_user 
    has_permission_on :comments, :to => :destroy do
      if_attribute :commentable => { :user => is { user } }
    end
    
  end

end
