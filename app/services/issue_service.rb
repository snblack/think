class IssueService
  def self.issue(query, where)
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
    else
      'Пробуйте еще раз'
    end
  end
end
