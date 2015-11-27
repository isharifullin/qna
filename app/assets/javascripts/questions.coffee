# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#edit_question_link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId');
    $('form#edit_question_' + question_id).show();

$(document).ready(ready)
$(document).on('page:load', ready)