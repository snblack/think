class CommentsController < ApplicationController
  after_action :publish_comment, only: [:create]

  def create
    @parent  = parent
    @comment = @parent.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
    find_question
  end

  private

  def parent
    if params[:question_id]
      question = Question.find(params[:question_id])
      gon.question_id = question.id
      return question
    else params[:answer_id]
      answer = Answer.find(params[:answer_id])
      gon.answer_id = answer.id
      return answer
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_question
    if @comment.commentable.class == Question
      @question = @comment.commentable

    elsif @comment.commentable.class == Answer
      @question = @comment.commentable.question
    end
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "question_#{@question.id}",
      @comment
    )
  end

end
