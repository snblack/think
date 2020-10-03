require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value("https://www.google.com/").for(:url) }
  it { should_not allow_value("foo").for(:url) }

  it 'method right work with links' do
    gist1 = Link.new(url: 'https://gist.github.com/snblack/9ff863f3ace404d31bf565ffddad832d')
    gist2 = Link.new(url: 'https://vk.com/feed')

    expect(gist1).to be_gist
    expect(gist2).to_not be_gist
  end
end
