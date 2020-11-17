class SubscriptionsController < ApplicationController

  before_action :find_question, only: %i[create destroy]
  before_action :find_subscription, only: %i[destroy]

  authorize_resource

  def create
    if !@question.followers.exists?(current_user.id)
      @question.followers.push(current_user)
    end
  end

  def destroy
    if @subscription&.persisted?
      @subscription.destroy
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
    gon.question_id = @question.id
  end

  def find_subscription
    @subscription = Subscription.find_by(user_id: current_user.id, question_id: @question.id)
  end

end
