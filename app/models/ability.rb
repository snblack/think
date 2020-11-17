# frozen_string_literal: true

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
    guest_abilities
    can :create, [Question, Answer, Comment, Vote]
    can [:up, :down], [Question, Answer]
    can [:mark_as_best], Answer, question: { user: { id: user.id } }
    can [:update, :destroy], [Question, Answer], user_id: user.id
    can [:destroy], Link, linkable: { user: { id: user.id }}
    can [:destroy], File, record: { user: { id: user.id }}
    can [:create], Subscription
    can [:destroy], Subscription, user_id: user.id
  end
end
