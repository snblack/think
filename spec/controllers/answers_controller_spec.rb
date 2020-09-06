require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), user: user, question_id: question.id} }.to change(question.answers, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id}
        expect(response).to redirect_to assigns(:question)
      end

      it 'created answer belong to current_user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id}
        expect(assigns(:answer).user).to eq subject.current_user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id} }.to_not change(Answer, :count)
      end
      it "render questions show" do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id}
        expect(subject).to render_template("questions/show")
      end

    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) {create(:answer, user: user, question: question)}

    context 'for author' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer} }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'not author' do
      before do
        login(user)
        user2 = create(:user)
        login(user2)
      end

      it 'trying delete the question' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Question, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end

    end
  end
end
