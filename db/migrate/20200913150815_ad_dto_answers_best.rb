class AdDtoAnswersBest < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :best, :boolean
    add_index :answers, :best, name: "index_best"
  end
end
