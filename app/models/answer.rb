class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  default_scope {order(best: :desc)}

  validates :body, presence: true

  def choose_best
    self.question.answers.each do |answer|
        if answer.best == true
          answer.best = false
          answer.save!
        end
    end

    self.best = TRUE
    self.save!
  end
end
