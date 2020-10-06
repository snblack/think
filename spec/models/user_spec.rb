require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:rewards) }

  it { should validate_presence_of :email}
  it { should validate_presence_of :password}

  let(:user) {create(:user)}
  let(:question) { create(:question, user: user) }

  it 'author' do
    expect(user).to be_author_of(question)
  end

  it 'not author' do
    user2 = create(:user)
    expect(user2).to_not be_author_of(question)
  end

end
