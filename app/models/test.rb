class Test < ApplicationRecord
  validates :title, presence: true
  has_many :questions, dependent: :delete_all
end
