class FilesController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])

    if @file.record_type == 'Question'
      question = Question.find(@file.record_id)

      if current_user.author_of?(question)
        @file.purge
        redirect_to question_path(question), notice: "File deleted"
      else
        redirect_to question_path(question), notice: "You not Athor of question"
      end
    end

    if @file.record_type == 'Answer'
      answer = Answer.find(@file.record_id)

      if current_user.author_of?(answer)
        @file.purge
        redirect_to question_path(answer.question), notice: "File deleted"
      else
        redirect_to question_path(answer.question), notice: "You not Athor"
      end
    end
  end
end
