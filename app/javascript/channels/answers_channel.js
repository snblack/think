import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
  connected() {
    this.perform("follow",  {question_id: gon.question_id })
  },

  received(answer) {
    if (gon.user_id != answer.user_id) {
      const simple_answer = "<p>" + answer.body + "</p>" +
                            "<p>" + "Rating:" + answer.rating + "</p>"

      $('.answers').append(simple_answer);
      $('.new-answer #answer_body').val('');
    }
  }
});
