require 'rails_helper'

describe 'Answers API' do
  describe 'GET #index' do
    let!(:question) { create(:question) }


    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(3).at_path("answers")
      end

      %W(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      let!(:comment) { create(:comment, commentable: answer) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end
      
      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end
        
        it "contains name" do
          expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("answer/attachments/0/name")
        end
      
        it "contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
        end
      end

      context 'comments' do    
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %W(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end      
    end
  end

  describe 'POST #create' do
    let!(:question) { create(:question) }
    
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end

      it 'does not save new question in database' do
        expect{ 
          post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: '1234'
        }.to_not change(Question, :count)
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'returns 200 status' do
        post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token 
        expect(response).to be_success
      end

      it 'saves new answer in database' do
        expect{ 
        post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token 
        }.to change(question.answers, :count).by(1)
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token      
          expect(response.body).to have_json_path("answer/#{attr}")
        end
      end
    end
  end
end