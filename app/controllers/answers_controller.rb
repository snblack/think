class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new
    @question = Question.find(params[:id])
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user


    if @answer.save
      redirect_to question_path(@answer.question)
    else
      redirect_to question_path(@answer.question), notice: 'Question can not empty!'
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    question = answer.question

    if current_user.author_of?(question)
      answer.destroy
      redirect_to question_path(question), notice: 'Answer deleted'
    else
      redirect_to question_path(question), notice: "You can't dalete this answer"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
