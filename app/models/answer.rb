class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  scope :order_by_best, -> {order(best: :desc)}

  validates :body, presence: true

  def choose_best
    self.question.answers.update_all(best: false)
    self.update(best: true)
  end

end
