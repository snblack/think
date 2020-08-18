class Question < ApplicationRecord
  belongs_to :test
  has_many :answers

  validates :title, :body, presence: true
end
