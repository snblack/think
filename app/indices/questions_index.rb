ThinkingSphinx::Index.define :question, with: :real_time do
  #fileds
  indexes title, sortable: true
  indexes body
  # indexes user.email, as: :author, sortable: true

  # attributes
  # has user_id
end
