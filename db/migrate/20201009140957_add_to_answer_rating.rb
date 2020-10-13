class AddToAnswerRating < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :rating, :integer, default: 0, null: false
    add_index :answers, :rating, name: "index_rating_of_answer"
  end
end
