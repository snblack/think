import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    this.perform("follow",  {question_id: gon.question_id })
  },

  received(comment) {
    if (comment.commentable_type == 'Answer') {
      $(".answer-comments-" + comment.commentable_id).find(".comments").append("<p>" + comment.body + "</p>")
    } else if (comment.commentable_type == 'Question') {
      $(".question-comments").find(".comments").append("<p>" + comment.body + "</p>")
    }
  }
});
