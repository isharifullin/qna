json.extract! @question, :id
json.rating @question.votes.rating
json.voted current_user.voted_for?(@question)
json.upvote_url upvote_question_path(@question)
json.downvote_url downvote_question_path(@question)
json.unvote_url unvote_question_path(@question)