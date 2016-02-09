json.extract! @answer, :id, :question_id, :body, :created_at, :updated_at
json.user @answer.user, :id
json.update_url  question_answer_path(@answer.question, @answer)
json.destroy_url question_answer_path(@answer.question, @answer)
json.make_best_url make_best_question_answer_path(@answer.question, @answer)
json.current_user_id current_user.id
json.question_user_id @answer.question.user_id
json.created_time time_ago_in_words(@answer.created_at) 

json.attachments @answer.attachments do |a|
  json.id a.id
  json.file_name a.file.identifier
  json.file_url a.file.url
end