require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    it 'populates an array of all questions' do
      get :index, params: { query: question.title, where: 'All' }

      expect(response).to have_http_status(:ok)
    end

    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
