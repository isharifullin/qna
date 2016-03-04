shared_examples_for "votable" do
  describe 'PATCH #upvote' do
    
    it "save new upvote in the database for anothers votable" do
      expect { patch :upvote, id: anothers_votable, format: :json }.to change(anothers_votable.votes.upvotes, :count).by(1)
    end

    it "does not save new upvote in the database for own votable" do
      expect { patch :upvote, id: votable, format: :json }.to_not change(votable.votes.upvotes, :count)
    end

    it 'render votes' do
      patch :upvote, id: anothers_votable, format: :json
      expect(response).to render_template :vote
    end
  end

   describe 'PATCH #downvote' do
    
    it "save new downvote in the database for anothers votable" do
      expect { patch :downvote, id: anothers_votable, format: :json }.to change(anothers_votable.votes.downvotes, :count).by(1)
    end

    it "does not save new downvote in the database for own votable" do
      expect { patch :downvote, id: votable, format: :json }.to_not change(votable.votes.upvotes, :count)
    end

    it 'render votes' do
      patch :downvote, id: anothers_votable, format: :json
      expect(response).to render_template :vote
    end
  end

  describe 'PATCH #unvote' do
    let!(:vote) { create(:vote, votable: anothers_votable, user: @user) }
    it 'delete vote from database' do
      expect { patch :unvote, id: anothers_votable, format: :json }.to change(anothers_votable.votes, :count).by(-1)
    end

    it 'render votes' do
      patch :unvote, id: anothers_votable, format: :json
      expect(response).to render_template :vote
    end
  end   
end