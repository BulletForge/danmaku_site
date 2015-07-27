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
      return
    end

    # admin
    if user && user.admin?
      # can do everything
      can :manage, :all
      # but...
      # cannot login because he is already logged in
      cannot :create, UserSession
      return
    end

    # regular user
    if user
      # cannot login, he already did
      cannot :create, UserSession

      # can logout
      can :destroy, UserSession

      # manage his own profile
      can :manage, User do |u|
        u == user
      end

      # manage his own projects
      can :manage, Project do |project|
        project.user == user
      end

      # manage his own image if he can manage the project
      can :manage, Image do |image|
        image.project && can?(:manage, image.project)
      end

      # manage versions
      can :manage, Version do |version|
        version.project && can?(:manage, version.project)
      end

      # manage archives
      can :manage, Archive do |archive|
        archive.version && can?(:manage, archive.version)
      end

      can :read, :all
    end
  end
end
