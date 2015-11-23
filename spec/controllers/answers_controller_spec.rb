require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
	let(:question) { create(:question) }
	let(:answer) { create(:answer, user: @user, question: question)	 }
	let(:anothers_answer) { create(:answer, question: question) }

	describe 'POST #create' do
		context 'authenticated user' do
			sign_in_user

			context 'with valid attributes' do
				it 'save new Answer in database' do
					expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
				end

				it 'redirects to question' do 
					post :create, question_id: question, answer: attributes_for(:answer)
					expect(response).to redirect_to question_path(assigns(:question))
				end
			end

			context 'with invalid attributes' do
				it 'does not save the answer' do
					expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
				end			

				it 'renders question' do
					post :create, question_id: question, answer: attributes_for(:invalid_answer)
					expect(response).to render_template 'questions/show'
				end
			end
		end

		context 'non-authenticated user' do
			it 'does not save answer' do
				expect { post :create, question_id: question, answer: attributes_for(:answer) }.to_not change(Answer, :count)
			end
		end
	end

	describe 'DELETE #destroy' do
		sign_in_user

		context 'user is owner answer' do
			before { answer }

			it 'delete answer from database' do
				expect { delete :destroy, question_id: question, id: answer }.to change(Answer, :count).by(-1)
			end

			it 'redirects to question view' do
				delete :destroy, question_id: question, id: answer
				expect(response).to redirect_to question_path(assigns(:question))
			end
		end

		context 'user is not owner answer' do
			before { anothers_answer }

			it 'does not delete answer' do
				expect { delete :destroy, question_id: question, id: anothers_answer }.to_not change(Answer, :count)
			end

			it 'redirects to question view' do
				delete :destroy, question_id: question, id: anothers_answer
				expect(response).to redirect_to question
			end
		end
	end
end