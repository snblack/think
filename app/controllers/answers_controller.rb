class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy mark_as_best up down]
  after_action :publish_answer, only: [:create]

  authorize_resource

  include Voted

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    @comment_answer = @answer.comments.new
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = "Answer deleted"
    end
  end

  def mark_as_best
    if current_user.author_of?(@answer.question)
      @answer.choose_best
    end
  end

  private

  def publish_answer
    return if @answer.errors.any?
    AnswersChannel.broadcast_to(@question, @answer)
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
