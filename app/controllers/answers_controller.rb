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
    if @answer.user != current_user
      if status == 'positive'
        errors_vote

      elsif status == 'negativ'
        cancel_vote

      else
        create_vote(true)
        respond_create
      end

    else
      errors_user
    end
  end

  def down
    if @answer.user != current_user
      if status == 'positive'
        cancel_vote

      elsif status == 'negativ'
        errors_vote

      else
        create_vote(false)
        respond_create
      end
    else
      errors_user
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

  def create_vote(positive_value)
    Answer.transaction do
      current_user.votes.new(positive: positive_value)
      @answer.votes << current_user.votes.last
    end

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

  def status
    @answer.status_vote(current_user)
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
    positive_votes = answer.votes.where(positive: true).count
    negative_votes = answer.votes.where(positive: false).count

    rating = positive_votes - negative_votes

    @answer.rating = rating
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
