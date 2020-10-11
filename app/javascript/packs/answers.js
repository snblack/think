$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('.vote_answer_up')
      .on('ajax:success', function(e) {
        var answer = e.detail[0]
        $('p.rating_answer_' + answer.id).html('<p>' + answer.rating + '</p>')
        $('.vote_answer_up.id-' + answer.id).addClass('hidden')
        $('.vote_answer_down.id-' + answer.id).removeClass('hidden')
      })
      .on('ajax:error', function (e) {
        var errors = e.detail[0];
        $.each(errors, function(index, value) {
          $('.answer-errors').html('<p>' + value + '</p>');
      })
  });

  $('.vote_answer_down')
      .on('ajax:success', function(e) {
        var answer = e.detail[0]
        $('p.rating_answer_' + answer.id).html('<p>' + answer.rating + '</p>')
        $('.vote_answer_down.id-' + answer.id).addClass('hidden')
        $('.vote_answer_up.id-' + answer.id).removeClass('hidden')
      })
      .on('ajax:error', function (e) {
        var errors = e.detail[0];
        $.each(errors, function(index, value) {
          $('.answer-errors').html('<p>' + value + '</p>');
      })
  });
});
