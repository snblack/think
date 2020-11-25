class SearchesController < ApplicationController

  authorize_resource

  def index
    query = params[:query]
    where = params[:where]

    @issue = IssueService.issue(query, where)
  end
end
