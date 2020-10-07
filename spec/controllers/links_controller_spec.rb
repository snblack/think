require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_links, user: user) }
  let(:answer) { create(:answer, :with_links, user: user, question: question) }

  describe 'DELETE #destroy of question' do
    context 'for author' do
      before { login(user) }

      it 'deletes links of the question' do
        expect(question.links.count).to eq 2
        expect { delete :destroy, params: { id: question.links[0].id } }.to change(Link, :count).by(-1)
      end

      it 'redirects to root' do
        delete :destroy, params: { id: question.links[0].id }
        expect(response).to redirect_to root_path
      end
    end

    context 'not author' do
      before do
        user2 = create(:user)
        login(user2)
      end

      it 'trying delete the link of question' do
        question.reload
        expect do
          delete :destroy, params: { id: question.links[0].id }
          delete :destroy, params: { id: question.links[1].id }
        end.to_not change(Link, :count)
      end
    end
  end

  describe 'DELETE #destroy of answer' do
    context 'for author' do
      before { login(user) }

      it 'deletes links of the answer' do
        expect(answer.links.count).to eq 2
        expect { delete :destroy, params: { id: answer.links[0].id } }.to change(Link, :count).by(-1)
      end

      it 'redirects to root_path' do
        delete :destroy, params: { id: answer.links[0].id }
        expect(response).to redirect_to root_path
      end
    end

    context 'not author' do
      before do
        user2 = create(:user)
        login(user2)
      end

      it 'trying delete the file of answer' do
        answer.reload
        expect do
          delete :destroy, params: { id: answer.links[0].id }
          delete :destroy, params: { id: answer.links[1].id }
        end.to_not change(Link, :count)
      end
    end
  end
end
