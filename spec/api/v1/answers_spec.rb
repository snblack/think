require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) {{"ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let(:access_token) {create(:access_token)}

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body user_id question_id best created_at updated_at].each do |attr|
          expect(json['answers'].first[attr]).to eq answers.first.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, :with_files, question: question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:link) { create(:link, linkable: answer) }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns answer' do
        expect(json.size).to eq 1
      end

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains comments object' do
        expect(json['answer']['comments'].first['id']).to eq answer.comments.first.id
      end

      it 'contains files url' do
        expect(json['answer']['files'].first['id']).to eq answer.files.first.id
      end

      it 'contains links url' do
        expect(json['answer']['links'].first['id']).to eq answer.links.first.id
      end
    end
  end

  describe 'POST /api/v1/questions/question_id/answers/' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}

      before {post api_path, params: {
        access_token: access_token.token,
        answer: {
          user_id: user.id,
          question_id: question.id,
          body: 'test Body'
        }
        }, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns answer' do
        expect(json.size).to eq 1
      end

      it 'contains answer body of object' do
        expect(json['answer']['body']).to eq "test Body"
      end
    end

  end

  describe 'PATCH /api/v1/answers/:id' do

    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}

      before {patch api_path, params: {
        access_token: access_token.token,
        answer: {
          body: 'Body edited',
          user_id: user.id
        }
        }, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns answer' do
        expect(json.size).to eq 1
      end

      it 'contains edited question' do
        expect(json['answer']['body']).to eq "Body edited"
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do

    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}

      before {delete api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns about action' do
        expect(json).to eq 'Answer was deleted'
      end
    end
  end
end
