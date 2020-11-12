require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{"ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, :with_files) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let!(:answer) { create(:answer, question: question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let!(:comment) { create(:comment, commentable: question) }
      let!(:link) { create(:link, linkable: question) }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns question' do
        expect(json.size).to eq 1
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(json['question'][attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(json['question']['user']['id']).to eq question.user.id
      end

      it 'contains comments object' do
        expect(json['question']['comments'].first['id']).to eq question.comments.first.id
      end

      it 'contains files url' do
        expect(json['question']['files'].first['id']).to eq question.files.first.id
      end

      it 'contains links url' do
        expect(json['question']['links'].first['id']).to eq question.links.first.id
      end

      describe 'answer' do
        it 'returns  answer' do
          expect(json['question']['answers'].size).to eq 1
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(json['question']['answers'].first[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions/' do
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let(:question) { create(:question) }
      let(:user) { create(:user) }

      before {post api_path, params: {
        access_token: access_token.token,
        question: {
          user_id: user.id,
          title: 'test Title',
          body: 'test Body'
        }
        }, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns question' do
        expect(json.size).to eq 1
      end

      it 'contains question title and body of object' do
        expect(json['question']['title']).to eq "test Title"
        expect(json['question']['body']).to eq "test Body"
      end
    end
  end

  describe 'PATCH /api/v1/questions/' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}

      before {patch api_path, params: {
        access_token: access_token.token,
        question: {
          user_id: user.id,
          title: 'Title edited',
          body: 'Body edited'
        }
        }, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns edited question' do
        expect(json.size).to eq 1
      end

      it 'contains edited question' do
        expect(json['question']['title']).to eq "Title edited"
        expect(json['question']['body']).to eq "Body edited"
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

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
        expect(json).to eq 'Question was deleted'
      end
    end
  end
end
