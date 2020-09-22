class FilesController < ApplicationController
  def destroy
    file = ActiveStorage::Attachment.find(params[:id])
    record = file.record

    notice = if current_user.author_of?(record) && file.purge
              "File deleted"
             else
              "You not authorized"
             end
    redirect_back(fallback_location: root_path), notice: notice
  end
end
