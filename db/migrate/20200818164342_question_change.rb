class QuestionChange < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :test, index: true, foreign_key: true
  end
end
