require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:answers).dependent(:delete_all) }
  it { should have_many(:links).dependent(:delete_all) }
  it { should have_one(:reward).dependent(:delete) }
  it { should have_many(:votes).dependent(:delete_all) }
  it { should have_many(:comments).dependent(:delete_all) }

  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }


  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  # describe 'reputation' do
  #   let(:question) { build(:question) }
  #
  #   it 'calls ReputationJob' do
  #     expect(ReputationJob).to receive(:perform_later).with(question)
  #     question.save!
  #   end
  # end

  describe 'add_to_followers' do
    let(:question) { create(:question) }

    it 'Author adds to followers' do
      expect(question.followers.count).to eq 1
      expect(question.followers.first).to eq question.user
    end
  end

end
