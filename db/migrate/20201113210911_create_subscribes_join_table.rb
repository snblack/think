class CreateSubscribesJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :questions, :users do |t|
      # t.index [:question_id, :user_id]
      t.index [:user_id, :question_id], unique: true
    end
  end
end
