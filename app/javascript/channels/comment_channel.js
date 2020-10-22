import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    this.perform("follow",  {question_id: gon.question_id})
  },

  received(data) {
    if (data.commentable_type == 'Answer') {
      $(".answer-comments").find(".comments").append("<p>" + data.body + "</p>")
    } else if (data.commentable_type == 'Question') {
      $(".question-comments").find(".comments").append("<p>" + data.body + "</p>")
    }
  }
});
