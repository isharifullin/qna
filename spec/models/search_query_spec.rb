require 'rails_helper'

RSpec.describe SearchQuery, type: :model do
  describe 'create subscription for question author' do
    let(:query) { SearchQuery.new(query_body: 'example', query_object: 'All') }
    let(:invalid_query) { SearchQuery.new(query_body: '', query_object: 'All') }
    
    it 'does not search if query nil' do
      expect(invalid_query.results).to eq []
    end

    %w(Question Answer Comment User).each do |resource|
      it "searches in #{resource}" do
        expect(resource.constantize).to receive(:search).with('example', {:order=>"created_at DESC"})
        query.query_object = resource
        query.results
      end
    end
  end  
end
