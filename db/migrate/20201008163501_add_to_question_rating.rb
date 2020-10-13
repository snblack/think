class AddToQuestionRating < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :rating, :integer, default: 0, null: false
    add_index :questions, :rating, name: "index_rating"
  end
end
