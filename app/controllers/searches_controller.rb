class SearchesController < ApplicationController

  authorize_resource

  def index
    query = params[:query]
    where = params[:where]

    @issue = issue(query, where)
  end

  private

  def issue(query, where)
    case where
    when 'All'
      ThinkingSphinx.search(query)
    when 'Question'
      Question.search(query)
    when 'Answer'
      Answer.search(query)
    when 'Comment'
      Comment.search(query)
    when 'User'
      User.search(query)
    end
  end
end
