require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  describe 'POST #index' do
    let!(:question) { create(:question, body: 'search question') }
    let!(:answer) { create(:answer, body: 'search answer') }
    let!(:comment) { create(:comment, commentable: question, body: 'search comment') }
    let!(:user) { create(:user, email: 'search@user.com') }

    before do
      index
      post :index, search_query: search
    end
      
    context 'with valid query' do    
      context 'All' do
        let!(:search) { {query_body: 'search', query_object: 'All'} }

        it 'assigns results to @results' do
          expect(assigns(:results)).to contain_exactly(question, answer, comment, user)     
        end

        it 'render template index' do 
          expect(response).to render_template  'search/index'
        end
      end

      context 'Question' do
        let!(:search) { {query_body: 'search', query_object: 'Question'} }

        it 'assigns results to @results' do
          expect(assigns(:results)).to contain_exactly(question)     
        end

        it 'render template index' do 
          expect(response).to render_template  'search/index'
        end
      end 

      context 'Answer' do
        let!(:search) { {query_body: 'search', query_object: 'Answer'} }

        it 'assigns results to @results' do
          expect(assigns(:results)).to contain_exactly(answer)     
        end

        it 'render template index' do 
          expect(response).to render_template  'search/index'
        end
      end 

      context 'Comment' do
        let!(:search) { {query_body: 'search', query_object: 'Comment'} }

        it 'assigns results to @results' do
          expect(assigns(:results)).to contain_exactly(comment)     
        end

        it 'render template index' do 
          expect(response).to render_template  'search/index'
        end
      end 

      context 'User' do
        let!(:search) { {query_body: 'search', query_object: 'User'} }

        it 'assigns results to @results' do
          expect(assigns(:results)).to contain_exactly(user)     
        end

        it 'render template index' do 
          expect(response).to render_template  'search/index'
        end
      end      
    end

    context 'with invalid query' do
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
