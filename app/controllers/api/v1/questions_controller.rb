class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[show update destroy]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: @question
    else
      render json: @question.errors.full_messages
    end
  end

  def update
    if current_resource_owner.author_of?(@question)
      @question.update(question_params)
    end

    render json: @question
  end

  def destroy
    if current_resource_owner.author_of?(@answer)
      if @question.destroy
        render json: 'Question was deleted'
      end
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                    links_attributes: [:name, :url],
                                    reward_attributes: [:name, :file])

  end
end
