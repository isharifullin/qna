ready = ->
  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    comment = $.parseJSON(data['comment'])
    commentable = '#' + comment.c_type + '_' + comment.c_id + '_comments'
    $("#{commentable}").append(JST["templates/comment"]({comment: comment}))
    $(".new_comment_form#comment_body").val('')
$(document).ready(ready)
$(document).on('page:load', ready)