class Ability
  include CanCan::Ability
  #:manage action is a wildcard meaning any action
  def initialize(user)
    can :create, Project
    can :manage, Project do |project|
      project.users.include?(user)
    end

    can :manage, Suggestion do |suggestion|
      suggestion.project.users.include?(user)
    end
  end
end
