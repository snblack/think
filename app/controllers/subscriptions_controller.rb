class SubscriptionsController < ApplicationController
  authorize_resource

  before_action :find_question, only: %i[create destroy]

  def create
    if !@question.followers.exists?(current_user.id)
      @question.followers.push(current_user)
    end
  end

  def destroy
    @subscription = Subscription.find_by(user_id: current_user.id, question_id: @question.id)
    @subscription.destroy
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
    gon.question_id = @question.id
  end

end
