import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
  connected() {
    this.perform("follow",  {question_id: gon.question_id })
  },

  received(data) {
    $('.answers').append(data);
  }
});
