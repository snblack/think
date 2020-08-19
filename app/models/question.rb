class Question < ApplicationRecord
  has_many :answers, dependent: :delete_all

  validates :title, :body, presence: true
end
