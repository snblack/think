class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :delete_all, as: :linkable
  has_many :votes, dependent: :delete_all, as: :votable
  has_many_attached :files
  accepts_nested_attributes_for :links, reject_if: :all_blank

  scope :order_by_best, -> {order(best: :desc)}

  validates :body, :rating, presence: true

  def choose_best
    Answer.transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)

      user.rewards << question.reward
    end
  end

end
