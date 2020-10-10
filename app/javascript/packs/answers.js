$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('p.vote_answer')
      .on('ajax:success', function(e) {
        var answer = e.detail[0]
        $('.answer-errors').html('');
        $('p.rating_answer_' + answer.id).html('<p>' + answer.rating + '</p>')

      })
      .on('ajax:error', function (e) {
        var errors = e.detail[0];
        $.each(errors, function(index, value) {
          $('.answer-errors').html('<p>' + value + '</p>');
      })
  });
});
