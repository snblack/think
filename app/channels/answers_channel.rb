class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    question = Question.find(data["question_id"])
    stream_for question
  end
end
