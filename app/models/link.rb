class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  validates :name, :url, presence: true
  validates :url, format: URI::regexp(%w[http https])

  GIST_REGEX = /gist.github.com\/\w*\/\w*$/

  def gist?
    self.url.match?(GIST_REGEX)
  end

  def create_url
    self.url + '.js'
  end

end
