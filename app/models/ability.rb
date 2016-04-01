class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    can :read, :all
    can :manage, [Question, Answer, Comment], user: user
    can :make_best, Answer, question: { user_id: user.id }
    can :me, User, user: user
    

    alias_action :subscribe, :unsubscribe, to: :subscription

    can :subscription, Question

    alias_action :upvote, :downvote, :unvote, to: :vote
    can :vote, [Question, Answer]
    cannot :vote, [Question, Answer], user: user
  end
end