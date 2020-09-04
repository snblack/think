require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #new' do
    before {get :new, params: { question_id: question.id}}

    it 'renders new view' do
    end
  end

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
      'тут нужен еще один тест, на связь созданного ответа и залогиненного юзера'
      it 'created answer belong to current_user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id}
        expect(assigns(:answer).user).to eq subject.current_user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id} }.to_not change(Answer, :count)
      end
    end
  end
end
