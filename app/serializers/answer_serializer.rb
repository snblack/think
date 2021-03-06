class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  has_many :comments
  has_many :files
  has_many :links

  attributes :id, :body, :user_id, :question_id, :best, :created_at, :updated_at, :files

  def files
    object.files.map do |file|
      { id: file.id, url: rails_blob_path(file, only_path: true) }
    end
  end

end
