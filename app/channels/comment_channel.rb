class CommentChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question_#{data["question_id"]}"
  end
  
end
