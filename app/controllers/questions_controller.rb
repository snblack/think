class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: %i[show update up down]
  after_action :publish_question, only: [:create]

  authorize_resource

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @reward = @question.reward
    @answer = @question.answers.new
    @answer.links.new
    @comment_question = @question.comments.new
    @comment_answer = @answer.comments.new
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

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
    gon.question_id = @question.id
  end

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question}
      )
    )
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                    links_attributes: [:name, :url, :_destroy],
                                    reward_attributes: [:name, :file])

  end

end
