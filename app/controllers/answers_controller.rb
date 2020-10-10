class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy mark_as_best up down]

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

  def up
    vote(1)
  end

  def down
    vote(-1)
  end

  def vote(value)
    return anauthorized! if current_user.author_of?(@answer)

    @answer.votes.find_by(user: current_user).destroy if @answer.votes.exists?
    @answer.votes.create(user: current_user, value: value)
    @answer.update(rating: @answer.votes.sum(:value))
    render json: @answer
  end

  private

  def anauthorized!
    render json: { error: :unauthorized }
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
