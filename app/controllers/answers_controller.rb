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
    if current_user.author_of?(@answer)
      errors_user

    else
      if @answer.votes.exists?

        if @answer.votes[0].value == 1
          errors_vote

        elsif @answer.votes[0].value == -1
          cancel_vote
        end

      else
        create_vote(1)
        respond_create
      end
    end
  end

  def down
    if current_user.author_of?(@answer)
      errors_user

    else
      if @answer.votes.exists?

        if @answer.votes[0].value == 1
          cancel_vote

        elsif @answer.votes[0].value == -1
          errors_vote
        end
      else
        create_vote(-1)
        respond_create
      end
    end
  end

  private

  def errors_user
    respond_to do |format|
      format.json do
        @answer.errors.add(:user, :invalid, message: "You can not vote for self answer")
        render json: @answer.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

  def create_vote(value_vote)
    @answer.votes.create(user: current_user, value: value_vote)

    update_rating(@answer)
  end

  def respond_create
    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json do
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def cancel_vote
    @answer.votes.find_by(user: current_user).destroy

    update_rating(@answer)

    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json do
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def errors_vote
    respond_to do |format|
      format.json do
        @answer.errors.add(:rating, :invalid, message: "You voted early")
        render json: @answer.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

  def update_rating(answer)
    rating = answer.votes.sum(:value)

    @answer.rating = rating
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
