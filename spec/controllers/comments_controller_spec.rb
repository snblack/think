require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #create for question' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect { post :create, params: { comment: attributes_for(:comment), user: user, question_id: question.id}, format: :js }.to change(question.comments, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question.id}, format: :js }.to_not change(Comment, :count)
      end
    end
  end

  describe 'GET #create for answer' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect { post :create, params: { comment: attributes_for(:comment), user: user, answer_id: answer.id}, format: :js }.to change(answer.comments, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { comment: attributes_for(:comment, :invalid), answer_id: answer.id}, format: :js }.to_not change(Comment, :count)
      end
    end
  end
end
