class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions_per_day = Question.today

    mail to: user.email
  end
end
