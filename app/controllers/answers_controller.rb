class AnswersController < ApplicationController

  def new

  end

  def create
    @question = Question.find(params['question_id'])
    answer = @question.answers.new(answer_params)

    if answer.save
      redirect_to question_path(answer.question)
    else
      render :new
    end
  end

  private

  def answer
    @question = Question.find(params[:question_id])
    @answer ||= params[:id] ? @question.answers.find(params[:id]) : @question.answers.new
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
