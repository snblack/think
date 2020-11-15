class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer, followers)
    NewAnswerService.new.send_notificatation(answer, followers)
  end
end
