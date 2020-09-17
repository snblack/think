require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), user: user, question_id: question.id}, format: :js }.to change(question.answers, :count).by(1)
      end
      it 'render create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id, format: :js}
        expect(response).to render_template :create
      end

      it 'created answer belong to current_user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id, format: :js}
        expect(assigns(:answer).user).to eq subject.current_user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id}, format: :js }.to_not change(Answer, :count)
      end
      it "render create template" do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id, format: :js }
        expect(subject).to render_template :create
      end

    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) {create(:answer, user: user, question: question)}

    context 'for author' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer}, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not author' do
      before do
        login(user)
        user2 = create(:user)
        login(user2)
      end

      it 'trying delete the question' do
        expect { delete :destroy, params: { id: answer }, format: :js}.to_not change(Question, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end

    end
  end
  describe 'PATH #update' do
    let!(:answer) {create(:answer,  question: question, user: user)}
    before {login(user)}

    context 'For Author with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }}, format: :js
        answer.reload

        expect(answer.body).to eq 'new body'
      end
      it 'renders update view' do
        patch :update, params: { id: answer, answer: {body: 'new body '}}, format: :js
        expect(response).to render_template :update
      end
    end
    context 'For Author with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid)}, format: :js
        end.to_not change(answer, :body)
      end
      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Not Author with valid attributes' do
      let!(:user2) {create(:user)}
      before {login(user2)}

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }}, format: :js
        answer.reload

        expect(answer.body).to_not eq 'new body'
      end
      it 'renders update view' do
        patch :update, params: { id: answer, answer: {body: 'new body '}}, format: :js
        expect(response).to render_template :update
      end
    end
    context 'Not Author with invalid attributes' do
      let!(:user2) {create(:user)}
      before {login(user2)}

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid)}, format: :js
        end.to_not change(answer, :body)
      end
      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

end
