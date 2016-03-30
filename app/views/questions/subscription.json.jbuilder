json.extract! @question, :id
json.subscriptions_count @question.subscriptions.count
json.subscribed current_user.subscribed_for?(@question)
json.subscribe_url subscribe_question_path(@question)
json.unsubscribe_url unsubscribe_question_path(@question)