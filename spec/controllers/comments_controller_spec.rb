require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  
  describe 'POST #create' do    
    context 'authenticated user' do
    let(:question) { create(:question) }    
    let(:answer) { create(:answer, question: question) }   
    sign_in_user

      context 'for question' do
        context 'with valid attributes' do
          it 'save new commemt in database' do
            expect { post :create, commentable: 'questions', question_id: question,
             comment: attributes_for(:comment), format: :json }.to change(question.comments, :count).by(1)
          end

          it 'render template show' do 
            post :create, commentable: 'questions', question_id: question, comment: attributes_for(:comment), format: :json
            expect(response).to render_template  'comments/show.json.jbuilder'
          end
        end

        context 'with invalid attributes' do
          it 'does not save the comment' do
            expect { post :create, commentable: 'questions', question_id: question,
             comment: attributes_for(:invalid_comment), format: :json }.to_not change(question.comments, :count)
          end
        end
      end

      context 'for answer' do
        context 'with valid attributes' do
          it 'save new commemt in database' do
            expect { post :create, commentable: 'answers', answer_id: answer,
             comment: attributes_for(:comment), format: :json }.to change(answer.comments, :count).by(1)
          end

          it 'render template show' do 
            post :create, commentable: 'answers', answer_id: answer, comment: attributes_for(:comment), format: :json
            expect(response).to render_template  'comments/show.json.jbuilder'
          end
        end

        context 'with invalid attributes' do
          it 'does not save the comment' do
            expect { post :create, commentable: 'answers', answer_id: answer,
             comment: attributes_for(:invalid_comment), format: :json }.to_not change(answer.comments, :count)
          end     
        end
      end
    end
    context 'non-authenticated user' do
    let(:question) { create(:question) }    
    let(:answer) { create(:answer, question: question) }   
      it 'does not save comment for question' do
        expect { post :create, commentable: 'questions', question_id: question,
          comment: attributes_for(:comment), format: :json }.to_not change(question.comments, :count)
      end
        it 'does not save comment for answer' do
          expect { post :create, commentable: 'answers', answer_id: answer,
           comment: attributes_for(:invalid_comment), format: :json }.to_not change(answer.comments, :count)
      end
    end
  end

  describe 'DELETE #destroy' do    
    let(:question) { create(:question) }    
    let(:answer) { create(:answer, question: question) }
    
    context 'authenticated user' do
      sign_in_user
      let!(:another_comment) { create(:comment, commentable: question) }
      let!(:comment) { create(:comment, commentable: question, user: @user) }
      context 'own comment' do
        it 'delete commemt from database' do
          expect { delete :destroy, id: comment, format: :js }.to change(question.comments, :count).by(-1)
          expect(response).to render_template 'destroy'
        end
      end

      context 'anothers comment' do
        it 'redirects to question view' do 
          delete :destroy, id: another_comment, format: :js 
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'Non-authenticated user' do
      let!(:comment) { create(:comment, commentable: question) }
      
      it 'does not delete commemt from database' do
        expect { delete :destroy, id: comment, format: :js }.to_not change(question.comments, :count)
      end
    end
  end
end
