class Ability
  include CanCan::Ability

  def initialize(user)
    current_user = user
    if user.role == "admin"
      can :manage, :all
    else
      can :update, User, :id => current_user.id
    end
  end
end
