require 'rails_helper'

RSpec.describe NewAnswerService do
  let(:question) {create(:question)}
  let(:users) {create_list(:user, 3)}
  let(:answer) {create(:answer, question: question)}

  it 'sends notification email to foloowers' do
    question.followers << users
    question.followers.each {|follower| expect(NewAnswerMailer).to receive(:send_to_followers).with(answer, follower).and_call_original}
    subject.send_notificatation(answer, question.followers)
  end
end
