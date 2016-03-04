require 'rails_helper'

describe 'Answers API' do
    let!(:question) { create(:question) }
    let(:access_token) { create(:access_token) }
  
  describe 'GET #index' do
    it_behaves_like "API authenticable"

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end    
    
    context 'authorized' do  
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

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
    it_behaves_like "API authenticable"

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end    

    let!(:answer) { create(:answer, question: question) } 
    
    context 'authorized' do    
      let!(:attachment) { create(:attachment, attachable: answer) }
      let!(:comment) { create(:comment, commentable: answer) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

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
    it_behaves_like "API authenticable"

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json, answer: attributes_for(:answer) }.merge(options)
    end    

    context 'authorized' do
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