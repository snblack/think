require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  let!(:user) { create(:user) }

  describe 'POST #create' do
    context 'not authenticated user' do
      it 'does not save the question' do
        expect { post :create, params: { subscription: attributes_for(:subscription), user: user, question_id: question.id }, format: :js  }.to change(Subscription, :count).by(0)
      end
    end

    context 'with valid attributes' do
      before { login(user) }
      it 'saves a new subsription in the database' do
        expect { post :create, params: { subscription: attributes_for(:subscription), user: user, question_id: question.id }, format: :js  }.to change(Subscription, :count).by(1)
      end
    end

  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }
    let!(:subscription) {create(:subscription, user_id: user.id, question_id: question.id)}

    context 'for owner of subscribes' do
      before { login(user) }

      it 'deletes the subscription' do
        expect { delete :destroy, params: { question_id: question.id} }.to change(Subscription, :count).by(-1)
      end
    end

    context 'not owner of subscribes' do
      before do
        login(user)
        user2 = create(:user)
        login(user2)
      end

      it 'trying delete the question' do
        expect { delete :destroy, params: { question_id: question.id} }.to_not change(Subscription, :count)
      end
    end
  end

end
