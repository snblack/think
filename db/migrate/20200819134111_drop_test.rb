class DropTest < ActiveRecord::Migration[6.0]
  def change
    remove_reference :questions, :test, index: true, foreign_key: true
    drop_table :tests
  end
end
