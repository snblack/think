require 'rails_helper'

RSpec.shared_examples 'votable answer' do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'PUT #up' do
    before { login(user) }

    context 'Not author' do
      it 'saves a new vote in the database' do
        expect { put :up, params: { answer: answer.id} }.to change(Vote, :count).by(1)
      end
    end

    context 'Author' do
      it 'does not save the question' do
        expect { put :up, params: { answer: answer.id, user: user} }.to_not change(Vote, :count)
      end
    end
  end
end

RSpec.describe AnswersController, type: :controller do
  it_behaves_like "votable answer"
end
