require "rails_helper"

RSpec.describe NewAnswerMailer, type: :mailer do
  describe "notification_to_followers" do
    let(:answer) {build(:answer)}
    let(:follower) {build(:user)}
    let(:mail) { NewAnswerMailer.send_to_followers(answer, follower) }

    it "renders the headers" do
      expect(mail.subject).to eq("Send to followers")
      expect(mail.to).to eq([follower.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
