# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#edit_question_link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId');
    $('form#edit_question_' + question_id).show();

  $('.vote_question').bind 'ajax:success', (e, data, status, xhr) ->
    question = $.parseJSON(xhr.responseText)
    $(".vote_question").html(JST["templates/vote_bar"]({object: question}))

  PrivatePub.subscribe '/questions/index', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions_list').append(JST["templates/question"]({question: question}))

$(document).ready(ready)
$(document).on('page:load', ready)