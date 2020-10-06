class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :delete_all, as: :linkable
  has_many_attached :files
  accepts_nested_attributes_for :links, reject_if: :all_blank

  scope :order_by_best, -> {order(best: :desc)}

  validates :body, presence: true

  def choose_best
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)

      self.user.rewards << self.question.reward
    end
  end

end
