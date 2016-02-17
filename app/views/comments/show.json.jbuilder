json.extract! @comment, :id, :body, :user_id, :created_at, :updated_at
json.url comment_path(@comment)
json.current_user_id current_user.id
json.created_time time_ago_in_words(@comment.created_at)
json.c_type @comment.commentable_type.downcase
json.c_id @comment.commentable_id
