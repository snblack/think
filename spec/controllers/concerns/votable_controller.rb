require 'rails_helper'

RSpec.shared_examples 'votable' do |model|
  let(:user) { create(:user) }
  let(:resource) { create(model, user: user) }

  describe 'PUT #up' do
    before { login(user) }

    context 'Not author' do
      it 'saves a new vote in the database' do
        expect { put :up, params: { model => resource.id} }.to change(Vote, :count).by(1)
      end
    end

    context 'Author' do
      it 'does not save the resource' do
        expect { put :up, params: { model => resource.id, user: user} }.to_not change(Vote, :count)
      end
    end
  end
end

RSpec.describe AnswersController, type: :controller do
  it_behaves_like "votable", :answer
end

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like "votable", :question
end
