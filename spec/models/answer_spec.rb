require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:links).dependent(:delete_all) }
  it { should have_one(:reward) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :links }

  let(:user) {create(:user)}
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question) }

  it 'atrributes of answer have right value' do
    answer.choose_best
    expect(answer).to be_best
  end

  it 'best answer only one' do
    answer.choose_best
    answer.save

    answer2 = create(:answer, question: question)
    answer2.choose_best

    answer.reload

    expect(answer).to_not be_best
    expect(answer2).to be_best
  end

  it 'method not change answer of other questions' do
    answer.choose_best
    answer.save

    question2 = create(:question, user: user)
    answer2 = create(:answer, question: question2)
    answer2.choose_best

    answer.reload

    expect(answer).to be_best
    expect(answer2).to be_best
  end

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
