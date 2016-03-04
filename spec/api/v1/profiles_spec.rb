require 'rails_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  
  describe 'GET /me' do
    it_behaves_like "API authenticable"

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end   

    context 'authorized' do
      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET #index' do
    it_behaves_like "API authenticable"

    def do_request(options = {})
      get '/api/v1/profiles', { format: :json }.merge(options)
    end   


    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:user) { users.first }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }
      
      it 'returns list of users' do
        expect(response.body).to have_json_size(3).at_path("profiles")
      end

      %W(id email created_at updated_at admin).each do |attr|
        it "user object contains #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("profiles/0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path("profiles/0/#{attr}")
        end
      end

      it 'does not contain current user' do
        expect(response.body).to_not include_json(me.to_json)
      end
    end
  end
end