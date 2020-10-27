require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:rewards) }
  it { should have_many(:votes) }

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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

end
