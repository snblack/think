$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  });

  $('p.vote_question')
      .on('ajax:success', function(e) {
        var question = e.detail[0]
        $('.question-errors').html('');
        $('p.rating_question_' + question.id).html('<p>' + question.rating + '</p>')
      })
      .on('ajax:error', function (e) {
        var errors = e.detail[0];
        $.each(errors, function(index, value) {
          $('.question-errors').html('<p>' + value + '</p>');
      })
  });
});
