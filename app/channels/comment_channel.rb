class CommentChannel < ApplicationCable::Channel
  def follow(data)
    question = Question.find(data["question_id"])
    stream_from "question_#{question.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def parent(data)
    return Question.find(data["question_id"]) if data["question_id"]
    return Answer.find(data["answer_id"]) if data["answer_id"]
  end
end
