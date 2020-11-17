class NewAnswerMailer < ApplicationMailer
  def send_to_followers(answer, follower)
    @answer = answer

    mail to: follower.email
  end
end
