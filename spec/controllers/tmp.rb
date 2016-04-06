require 'rails_helper'
require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  describe 'POST #result' do
    let!(:question) { create(:question, body: 'search question') }
    let!(:answer) { create(:answer, body: 'search answer') }
    let!(:comment) { create(:comment, commentable: question, body: 'search comment') }
    let!(:user) { create(:user, email: 'search@user.com') }

    before do
      sphinx_index
      post :index, search_query: search
    end
      
    context 'with valid attributes' do    
      context 'All' do
        let!(:search) { {query_body: 'search', query_object: 'All'} }

        it 'assigns results to @results' do
          expect(assigns(:results)).to contain_exactly(question, answer, comment, user)     
        end

        it 'assigns search query to @search' do
          s = assigns(:search)
          expect(s.query_body).to eq search[query_body]
          expect(s.query_object).to eq search[query_object]     
        end

        it 'render template index' do 
          expect(response).to render_template  'search/index'
        end
      end
    end

    context 'with invalid result' do
      let!(:search) { {query_body: '', query_object: 'Attachment'} }
      
      it 'returns nil result' do
        expect(assigns(:results)).to eq []
      end     

      it 'render template index' do 
        expect(response).to render_template  'search/index'
      end
    end
  end
end
