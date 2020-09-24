require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_files, user: user) }
  let(:answer) { create(:answer, :with_files, user: user, question: question) }

  describe 'DELETE #destroy of question' do
    context 'for author' do
      before { login(user) }

      it 'deletes files of the question' do
        expect(question.files.count).to eq 2
        expect { delete :destroy, params: { id: question.files.blobs[0].id } }.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'redirects to root' do
        delete :destroy, params: { id: question.files.blobs[0].id }
        expect(response).to redirect_to root_path
      end
    end

    context 'not author' do
      before do
        user2 = create(:user)
        login(user2)
      end

      it 'trying delete the file of question' do
        question.reload
        expect do
          delete :destroy, params: { id: question.files.blobs[0].id }
          delete :destroy, params: { id: question.files.blobs[1].id }
        end.to_not change(ActiveStorage::Attachment, :count)
      end
    end
  end

  describe 'DELETE #destroy of answer' do
    context 'for author' do
      before { login(user) }

      it 'deletes files of the answer' do
        expect(answer.files.count).to eq 2
        expect { delete :destroy, params: { id: answer.files.blobs[0].id } }.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'redirects to root_path' do
        delete :destroy, params: { id: answer.files.blobs[0].id }
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
          delete :destroy, params: { id: answer.files.blobs[0].id }
          delete :destroy, params: { id: answer.files.blobs[1].id }
        end.to_not change(ActiveStorage::Attachment, :count)
      end
    end
  end
end
