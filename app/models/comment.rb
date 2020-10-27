class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  validates :body, presence: true
  belongs_to :user
end
