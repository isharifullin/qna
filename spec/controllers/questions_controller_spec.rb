require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, user: @user) }
  let(:anothers_question) { create(:question) }

  describe 'GET #index' do
  	let(:questions) { create_list(:question, 2) }
  	
    before { get :index }

    it 'populate an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
  	before { get :show, id: anothers_question }

  	it 'assigns requested question to @question' do
			expect(assigns(:question)).to eq anothers_question  		
  	end
  	
  	it 'renders show view' do
			expect(response).to render_template :show  		
  	end
  end

  describe 'GET #new' do
  	sign_in_user
    before {get :new}

  	it 'assigns a new Question to @question' do
  		expect(assigns(:question)).to be_a_new(Question)
  	end

  	it 'renders new view' do
  		expect(response).to render_template :new
  	end
  end

  describe 'GET #edit' do
    sign_in_user
  	before {get :edit, id: question}

  	 it 'assigns a requested Question to @question' do
  		expect(assigns(:question)).to eq question
  	end

  	it 'renders edit view' do
  		expect(response).to render_template :edit
  	end
  end

  describe 'POST #create' do
    context 'authenticated user' do
      sign_in_user

    	context 'with vilid attributes' do
    		it 'save new question in the database' do
    			expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
    		end

    		it 'redirects to show view' do
    			post :create, question: attributes_for(:question)
          
    			expect(response).to redirect_to question_path(assigns(:question))
    		end
    	end

    	context 'with invalid attributes' do
    		it 'does not save the question' do
    			expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
    		end

    		 it 're-renders new view' do
    			post :create, question: attributes_for(:invalid_question)

    			expect(response).to render_template :new
    		end
    	end
    end

    context 'non-authenticated user' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:question) }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do

    context 'authenticated user' do
      sign_in_user

      context 'with vilid attributes' do
        it 'assigns requested question to @question' do
          patch :update, id: question, question: attributes_for(:question)
          expect(assigns(:question)).to eq question     
        end

        it 'changes question attributes' do
          patch :update, id: question, question: {title: 'new title', body: 'new body'}
          question.reload
          expect(question.title).to eq 'new title'  
          expect(question.body).to eq 'new body'
        end

        it 'redirects to the updated question' do
          patch :update, id: question, question: attributes_for(:question)
          expect(response).to redirect_to question
        end
      end

      context 'with invilid attributes' do
        before { patch :update, id: question, question: {title: 'new title', body: nil} }
        it 'does not change question attributes' do
          old_title = question.title
          question.reload
          expect(question.title).to eq old_title 
          expect(question.body).to eq 'MyQuestionBody'
        end

        it 're-renders edit view' do
          expect(response).to render_template :edit
        end
      end

      context 'user is not owner question' do
        it 'does not change question attributes' do
          patch :update, id: anothers_question, question: {title: 'new title', body: 'new body'}
          anothers_question.reload
          expect(question.title).to_not eq 'new title'  
          expect(question.body).to_not eq 'new body'
        end
      end
    end

    context 'non-authenticated user' do
      it 'does not change question attributes' do
        patch :update, id: anothers_question, question: {title: 'new title', body: 'new body'}
        old_title = anothers_question.title
        anothers_question.reload
        expect(anothers_question.title).to eq old_title 
        expect(anothers_question.body).to eq 'MyQuestionBody'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      sign_in_user
      
      context 'user is owner question' do
        before { question }

        it 'deletes question' do
          expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
        end

        it 'redirects to index view' do
          delete :destroy, id: question
          expect(response).to redirect_to questions_path
        end
      end

      context 'user is not owner question' do
        before { anothers_question }

        it 'does not delete question' do
          expect { delete :destroy, id: anothers_question }.to_not change(Question, :count)
        end

        it 'redirects to question view' do
          delete :destroy, id: anothers_question
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end