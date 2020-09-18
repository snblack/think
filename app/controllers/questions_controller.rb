class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: %i[show update]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
    @answer = @question.answers.new
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
    @question = Question.find(params[:id])
  end

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end


end
