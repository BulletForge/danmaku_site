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

      can :read, :all
    end
  end
end
