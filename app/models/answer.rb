class Answer < ApplicationRecord
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
  belongs_to :question, touch: true
  belongs_to :user

  has_many :links, dependent: :delete_all, as: :linkable
  has_many :votes, dependent: :delete_all, as: :votable
  has_many :comments, dependent: :delete_all, as: :commentable
  has_many_attached :files
  accepts_nested_attributes_for :links, reject_if: :all_blank

  scope :order_by_best, -> {order(best: :desc)}

  validates :body, presence: true

  after_create :notification_for_followers

  def choose_best
    Answer.transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)

      user.rewards << question.reward
    end
  end

  private

  def notification_for_followers
    followers = self.question.followers.to_ary

    NewAnswerJob.perform_later(self, followers)
  end
end
