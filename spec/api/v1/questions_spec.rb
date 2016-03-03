require 'rails_helper'

describe 'Questions API' do
  describe 'GET #index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(3).at_path("questions")
      end

      %W(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'contains short title' do
        expect(response.body).to be_json_eql((question.title.truncate(10)).to_json).at_path("questions/0/short_title")
      end
    end
  end

  describe 'GET #show' do
    let!(:questions) { create_list(:question, 3) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:attachment) { create(:attachment, attachable: question) }
    let!(:comment) { create(:comment, commentable: question) }
    
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
 
      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end
        
        it "contains name" do
          expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("question/attachments/0/name")
        end
      
        it "contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
        end
      end

      context 'comments' do    
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %W(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end
 
      context 'answers' do    
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/answers")
        end

        %W(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST #create' do    
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions', question: attributes_for(:question), format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end

      it 'does not save new question in database' do
        expect{ 
          post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: '1234'
        }.to_not change(Question, :count)
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'returns 200 status' do
        post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token
        expect(response).to be_success
      end

      it 'saves new question in database' do
        expect{ 
          post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token
        }.to change(Question, :count).by(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token
          expect(response.body).to have_json_path("question/#{attr}")
        end
      end
    end
  end
end