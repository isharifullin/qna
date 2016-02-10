json.extract! @answer, :id
json.rating @answer.votes.rating
json.voted current_user.voted_for?(@answer)
json.upvote_url upvote_answer_path(@answer)
json.downvote_url downvote_answer_path(@answer)
json.unvote_url unvote_answer_path(@answer)