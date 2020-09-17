require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  let(:user) {create(:user)}
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question) }

  it 'atrributes of answer have right value' do
    answer.choose_best
    expect(answer.best).to eq true
  end

  it 'best answer only one' do
    answer.choose_best
    answer.save

    answer2 = create(:answer, question: question)
    answer2.choose_best

    answer.reload

    expect(answer.best).to eq false
    expect(answer2.best).to eq true
  end

  it 'method not change answer of other questions' do
    answer.choose_best
    answer.save

    question2 = create(:question, user: user)
    answer2 = create(:answer, question: question2)
    answer2.choose_best

    answer.reload

    expect(answer.best).to eq true
    expect(answer2.best).to eq true
  end
end
