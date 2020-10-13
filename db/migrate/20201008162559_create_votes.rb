class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :value, null: false
      t.references :user, index: true, foreign_key: true
      t.references :votable, polymorphic: true
      t.index ["value", "votable_type", "votable_id"], name: "index_type_and_votable", unique: true

      t.timestamps
    end
  end
end
