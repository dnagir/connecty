class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Suggestion do |suggestion|
      suggestion.project.users.include?(user)
    end
  end
end
