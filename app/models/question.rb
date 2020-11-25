class Question < ApplicationRecord
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
  
  has_many :answers, dependent: :delete_all
  has_many :links, dependent: :delete_all, as: :linkable
  has_many :comments, dependent: :delete_all, as: :commentable
  has_many :votes, dependent: :delete_all, as: :votable
  has_one :reward, dependent: :delete

  has_many :subscriptions
  has_many :followers, class_name: 'User', through: :subscriptions


  belongs_to :user
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  scope :today, -> {where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)}

  # after_create :calculate_reputation

  after_create :add_to_followers

  private

  def add_to_followers
    self.followers << self.user
  end

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

end
