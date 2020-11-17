require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:service) { double('Services::NewAnswerService') }
  let(:answer) {build(:answer)}
  let(:followers) {build(:user)}

  before do
    allow(NewAnswerService).to receive(:new).and_return(service)
  end

  it 'calls Service::NewAnswer#send_notificatation' do
    expect(service).to receive(:send_notificatation)
    NewAnswerJob.perform_now(answer, followers)
  end
end
