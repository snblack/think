class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
    @questions = Question.all
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question

    if current_user.author_of?(@answer)
      @answer.destroy

      respond_to do |format|
        format.js { flash.now[:notice] = "Answer deleted" }
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
