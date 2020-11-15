$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  });

  $('.vote_question_up')
      .on('ajax:success', function(e) {
        var question = e.detail[0]
        $('p.rating_question_' + question.id).html('<p>' + question.rating + '</p>')
        $('.vote_question_up.id-' + question.id).addClass('hidden')
        $('.vote_question_down.id-' + question.id).removeClass('hidden')
      })
      .on('ajax:error', function (e) {
        var errors = e.detail[0];
        $.each(errors, function(index, value) {
          $('.question-errors').html('<p>' + value + '</p>');
      })
  });

  $('.vote_question_down')
      .on('ajax:success', function(e) {
        var question = e.detail[0]
        $('p.rating_question_' + question.id).html('<p>' + question.rating + '</p>')
        $('.vote_question_down.id-' + question.id).addClass('hidden')
        $('.vote_question_up.id-' + question.id).removeClass('hidden')
      })
      .on('ajax:error', function (e) {
        var errors = e.detail[0];
        $.each(errors, function(index, value) {
          $('.question-errors').html('<p>' + value + '</p>');
      })
  });

  $('.subscribe')
      .on('ajax:success', function(e) {
        $('.subscribe').addClass('hidden')
        $('.unsubscribe').removeClass('hidden')
      })
      .on('ajax:error', function (e) {
        var errors = e.detail[0];
        $.each(errors, function(index, value) {
          $('.question-errors').html('<p>' + value + '</p>');
      })
  });

  $('.unsubscribe')
      .on('ajax:success', function(e) {
        $('.unsubscribe').addClass('hidden')
        $('.subscribe').removeClass('hidden')
      })
      .on('ajax:error', function (e) {
        var errors = e.detail[0];
        $.each(errors, function(index, value) {
          $('.question-errors').html('<p>' + value + '</p>');
      })
  });
});
