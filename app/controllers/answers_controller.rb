class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new
    @question = Question.find(params['question_id'])
    @answer = @question.answers.new
  end

  def create
    @question = Question.find(params['question_id'])
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@answer.question)
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
