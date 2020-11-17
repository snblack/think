class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :follower, class_name: 'User', foreign_key: 'user_id'
end
