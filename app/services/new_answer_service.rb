class NewAnswerService
  def send_notificatation(answer, followers)
    followers.each do |follower|
      NewAnswerMailer.send_to_followers(answer, follower).deliver_later
    end
  end
end
