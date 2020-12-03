class Comment < ApplicationRecord
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
  belongs_to :commentable, polymorphic: true, touch: true
  validates :body, presence: true
  belongs_to :user
end
