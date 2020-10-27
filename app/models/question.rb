class Question < ApplicationRecord
  has_many :answers, dependent: :delete_all
  has_many :links, dependent: :delete_all, as: :linkable
  has_many :comments, dependent: :delete_all, as: :commentable
  has_many :votes, dependent: :delete_all, as: :votable
  has_one :reward, dependent: :delete

  belongs_to :user
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

end
