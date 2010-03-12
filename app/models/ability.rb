class Ability
  include CanCan::Ability

  def initialize(user)
    # not logged in
    unless user
      # login
      can :create, UserSession
      # register
      can :create, User
      # read everything
      can :read, :all
    end
    
    # admin
    if user && user.admin?
      # can do everything
      can :manage, :all
      # but...
      # cannot login because he is already logged in
      cannot :create, UserSession
    end
    
    # regular user
    if user
      # cannot login, he already did
      cannot :create, UserSession
      
      # can logout
      can :destroy, UserSession
      
      # update his own profile
      can :update, User do |u|
        u == user
      end
      
      # he can vote if he cannot manage the version
      can :create, Vote do |vote|
        cannot?(:manage, vote.voteable)
      end      
      
      # manage his own projects
      can :manage, Project do |action, project|
        project.user == user
      end

      # manage his own image if he can manage the project
      can :manage, Image do |action, image|
        image.project && can?(:manage, image.project)
      end
      
      # manage versions
      can :manage, Version do |action, version|
        version.project && can?(:manage, version.project)
      end
      
      # manage archives
      can :manage, Archive do |action, archive|
        archive.version && can?(:manage, archive.version)
      end
      
      can :create, Comment
      
      # destroy comments if he wrote the comment
      # or he can manage the user or project the comment refers to
      can :destroy, Comment do |comment|
        comment.author == user || comment.commentable == user || ( comment.commentable.is_a?(Version) && can?(:manage, comment.commentable) )
      end
      
      can :read, :all
    end        
  end
end
