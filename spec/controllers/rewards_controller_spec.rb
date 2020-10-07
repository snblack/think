require 'rails_helper'
require 'rspec/rails'
require 'devise'

RSpec.describe RewardsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }

  # let!(:reward) { create(:reward, user: user, question: question) }
  # let!(:reward) { create(:reward, user: user, question: question) }

  describe 'GET #index' do
    let(:rewards) {create_list(:reward, 3, user: user, question:question)}

    before { login(user) }
    before { get :index }

    it 'populates an array of all rewards' do
      get :index

      expect(assigns(:rewards)).to match_array(rewards)
    end

    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
