class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  validates :name, :url, presence: true
  validates :url, format: URI::regexp(%w[http https])
  validates :url, url: true

  GIST_REGEX = /gist.github.com\/\w*\/\w*$/

  def gist?
    self.url.match?(GIST_REGEX)
  end

  def create_url
    uri = URI::parse(self.url + '.js')
    ERB::Util.html_escape(uri)
  end


end
