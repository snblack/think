class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy mark_as_best up down]
  after_action :publish_answer, only: [:create]

  include Voted

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
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
    # ActionCable.server.broadcast(@question, @answer
    #   ApplicationController.render(
    #   partial: 'answers/answer',
    #   locals: { question: @question, answer: @answer, current_user: current_user }
    # ))
    AnswersChannel.broadcast_to(@question,
      ApplicationController.render(
        partial: 'answers/answer',
        locals: { question: @question, answer: @answer, current_user: current_user }
      ))
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
