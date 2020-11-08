class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_answer, only: %i[show update destroy]

  authorize_resource

  def index
    @question = Question.find(params[:question_id])
    render json: @question.answers
  end

  def show
    render json: @answer
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    if @answer.save
      render json: @answer
    else
      render json: @answer.errors.full_messages
    end
  end

  def update
    if current_resource_owner.author_of?(@answer)
      @answer.update(answer_params)
    end

    render json: @answer
  end

  def destroy
    if current_resource_owner.author_of?(@answer)
      if @answer.destroy
        render json: 'Answer was deleted'
      end
    end
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

end
