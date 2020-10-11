$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  });

  $('p.vote_question.up')
      .on('ajax:success', function(e) {
        var question = e.detail[0]
        $('p.rating_question_' + question.id).html('<p>' + question.rating + '</p>')
        $('.vote_question.up').addClass('hidden')
        $('.vote_question.down').removeClass('hidden')
      })
      .on('ajax:error', function (e) {
        var errors = e.detail[0];
        $.each(errors, function(index, value) {
          $('.question-errors').html('<p>' + value + '</p>');
      })
  });
  $('p.vote_question.down')
      .on('ajax:success', function(e) {
        var question = e.detail[0]
        $('p.rating_question_' + question.id).html('<p>' + question.rating + '</p>')
        $('.vote_question.down').addClass('hidden')
        $('.vote_question.up').removeClass('hidden')
      })
      .on('ajax:error', function (e) {
        var errors = e.detail[0];
        $.each(errors, function(index, value) {
          $('.question-errors').html('<p>' + value + '</p>');
      })
  });
});
