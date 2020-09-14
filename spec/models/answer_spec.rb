require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  let(:user) {create(:user)}
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question) }

  it 'best answer' do
    expect(answer.choose_best).to eq TRUE
  end
end
