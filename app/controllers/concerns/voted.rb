require 'active_support/concern'

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[up down]
  end

  def up
    vote(1)
  end

  def down
    vote(-1)
  end

  def vote(value)
    return anauthorized! if current_user.author_of?(@votable)

    @votable.votes.find_by(user: current_user).destroy if @votable.votes.exists?
    @votable.votes.create(user: current_user, value: value)
    @votable.update(rating: @votable.votes.sum(:value))
    render json: @votable
  end

  def anauthorized!
    render json: { error: :unauthorized }, status: :unprocessable_entity
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
