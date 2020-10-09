class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.boolean :positive, null: false
      t.references :user, index: true, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end
  end
end
