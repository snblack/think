require 'rails_helper'

RSpec.shared_examples 'votable question' do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'PUT #up' do
    before { login(user) }

    context 'Not author' do
      it 'saves a new vote in the database' do
        expect { put :up, params: { id: question.id} }.to change(Vote, :count).by(1)
      end
    end

    context 'Author' do
      it 'does not save the question' do
        expect { put :up, params: { question: question.id, user: user} }.to_not change(Vote, :count)
      end
    end
  end

end

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like "votable question"
end
