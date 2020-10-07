class ChangeReward < ActiveRecord::Migration[6.0]
  def change
    drop_table :rewards do |t|
      t.string :name
      t.belongs_to :rewardable, polymorphic: true

      t.timestamps
    end

    create_table :rewards do |t|
      t.string :name
      t.references :question, index: true, foreign_key: true
      t.references :user, index: true

      t.timestamps
    end
  end


end
