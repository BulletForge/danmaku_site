class Ability
  include CanCan::Ability

  def initialize(user)
    # not logged in
    unless user
      can :manage, :all
      can :read, :all
    end
    
    # admin
    if user && user.admin?
      can :manage, :all
      can :read, :all
    end
    
    # regular user
    if user
      can :manage, :all
      can :read, :all
    end        
  end
end
