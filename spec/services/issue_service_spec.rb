require 'rails_helper'

RSpec.describe IssueService do
  let(:question) {create(:question)}
  let(:answer) {create(:answer, question: question)}
  let(:comment) {create(:comment, commentable: question)}
  let!(:user) {create(:user)}

  it 'return object after count issue' do
    expect(IssueService.issue(question.title, 'All').first).to eq question
    expect(IssueService.issue(answer.body, 'All').first).to eq answer
    expect(IssueService.issue(comment.body, 'All').first).to eq comment
    expect(IssueService.issue(user.name, 'All').first).to eq user
  end
  it 'return question after count issue' do
    expect(IssueService.issue(question.title, 'Question').first).to eq question
  end
  it 'return answer after count issue' do
    expect(IssueService.issue(answer.body, 'Answer').first).to eq answer
  end

  it 'return comment after count issue' do
    expect(IssueService.issue(comment.body, 'Comment').first).to eq comment
  end

  it 'return user after count issue' do
    expect(IssueService.issue(user.name, 'User').first).to eq user
  end
end
