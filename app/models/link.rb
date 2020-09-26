class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  validates :name, :url, presence: true

  validates :url, format: URI::regexp(%w[http https])
end
