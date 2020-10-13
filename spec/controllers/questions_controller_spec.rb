require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) {create_list(:question, 3)}

    before { get :index }

    it 'populates an array of all questions' do
      get :index

      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'Get #show' do
    before {get :show, params: { id: question }}

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'Get #new' do
    before { login(user) }

    before {get :new}

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'Get #edit' do
    before do
      login(user)
      get :edit, params: { id: question }
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question)} }.to change(Question, :count).by(1)
      end
      it 'redirects to show' do
        post :create, params: { question: attributes_for(:question)}
        expect(response).to redirect_to assigns(:question)
      end
      it 'connect with user' do
        post :create, params: { question: attributes_for(:question), user: user}
        expect(question.user) == user
      end

    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid)} }.to_not change(Question, :count)
      end

      it 're-renders new show' do
        post :create, params: { question: attributes_for(:question, :invalid)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) {create(:question, user: user)}

    context 'for author' do
      before { login(user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'not author' do
      before do
        login(user)
        user2 = create(:user)
        login(user2)
      end

      it 'trying delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)

        expect(response).to redirect_to question
      end
    end
  end

  describe 'PATH #update' do
    let!(:question) {create(:question, user: user)}
    before {login(user)}

    context 'For Author with valid attributes' do
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }}, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 'renders update view' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }}, format: :js
        expect(response).to render_template :update
      end
    end
    context 'For Author with invalid attributes' do
      let!(:user2) {create(:user)}
      before {login(user2)}

      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid)}, format: :js
        end.to_not change(question, :title)
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid)}, format: :js
        end.to_not change(question, :body)
      end
      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end

    end
    context 'Not Author with valid attributes' do
      let!(:user2) {create(:user)}
      before {login(user2)}

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }}, format: :js
        question.reload

        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
      it 'renders update view' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }}, format: :js
        expect(response).to render_template :update
      end
    end
    context 'Not Author with invalid attributes' do
      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid)}, format: :js
        end.to_not change(question, :title)
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid)}, format: :js
        end.to_not change(question, :body)
      end
      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end

    end
  end

  # describe 'PUT #up' do
  #   before { login(user) }
  #
  #   context 'Not author' do
  #     it 'saves a new vote in the database' do
  #       expect { put :up, params: { id: question.id} }.to change(Vote, :count).by(1)
  #     end
  #   end
  #
  #   context 'Author' do
  #     it 'does not save the question' do
  #       expect { put :up, params: { question: question.id, user: user} }.to_not change(Vote, :count)
  #     end
  #   end
  # end

end
