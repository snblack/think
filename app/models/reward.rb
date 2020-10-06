class Reward < ApplicationRecord
  belongs_to :rewardable, polymorphic: true

  has_one_attached :file

  validates :name, presence: true
end
