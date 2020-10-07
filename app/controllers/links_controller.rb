class LinksController < ApplicationController
  def destroy
    link = Link.find(params[:id])

    notice = if current_user.author_of?(link.linkable) && link.destroy
              "Link deleted"
             else
              "You not authorized"
             end

    redirect_back fallback_location: root_path, notice: notice
  end
end
