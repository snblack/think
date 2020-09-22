class Question < ApplicationRecord
  has_many :answers, dependent: :delete_all
  belongs_to :user
  has_many_attached :files

  validates :title, :body, presence: true
end
