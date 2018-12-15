class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :trello_ext_id, null: false
      t.string :name
      t.references :sprint, foreign_key: true

      t.timestamps
    end
  end
end
