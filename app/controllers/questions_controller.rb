class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: %i[show update up down]

  def index
    @questions = Question.all
  end

  def show
    @reward = @question.reward
    @answer = @question.answers.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @answer = @question.answers.new
    @question.links.new #.build
    @question.build_reward #.build
  end

  def edit

  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    end
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question succesfully created'
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Question deleted'
    else
      redirect_to question_path(question), notice: "You can't dalete this question"
    end
  end

  def up
    if @question.user != current_user
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
    if @question.user != current_user
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
        @question.errors.add(:user, :invalid, message: "You can not vote for self question")
        render json: @question.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

  def create_vote(positive_value)
    Question.transaction do
      current_user.votes.new(positive: positive_value)
      @question.votes << current_user.votes.last
    end

    update_rating(@question)
  end

  def respond_create
    respond_to do |format|
      if @question.save
        format.json { render json: @question }
      else
        format.json do
          render json: @question.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def cancel_vote
    @question.votes.find_by(user: current_user).destroy
    update_rating(@question)

    respond_to do |format|
      if @question.save
        format.json { render json: @question }
      else
        format.json do
          render json: @question.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def status
    @question.status_vote(current_user)
  end

  def errors_vote
    respond_to do |format|
      format.json do
        @question.errors.add(:rating, :invalid, message: "You voted early")
        render json: @question.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

  def update_rating(question)
    positive_votes = question.votes.where(positive: true).count
    negative_votes = question.votes.where(positive: false).count

    rating = positive_votes - negative_votes

    @question.rating = rating
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                    links_attributes: [:name, :url],
                                    reward_attributes: [:name, :file])

  end


end
