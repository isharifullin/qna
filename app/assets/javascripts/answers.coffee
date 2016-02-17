# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit_answer_link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit_answer_' + answer_id).show()

  $('form.new_answer').bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.answer-errors').html('')
    $.each errors, (index, value) ->
      $('.answer-errors').append value

  $('form.edit_answer').bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    ananswer_id = $(this).data('answerId');
    $.each errors, (index, value) ->
      $('#edit_answer_' + ananswer_id).append value

  $('.vote_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $("#vote_answer_#{answer.id}").html(JST["templates/vote_bar"]({object: answer}))

  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    answer = $.parseJSON(data['answer'])
    $('.answers').append(JST["templates/answer"]({answer: answer}))
    $('.form-control#answer_body').val('')

$(document).ready(ready)
$(document).on('page:load', ready)