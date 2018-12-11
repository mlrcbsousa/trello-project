class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :trello_ext_id, null: false, unique: true
      t.references :list, foreign_key: true
      t.integer :size, default: 2, null: false
      t.references :member, foreign_key: true

      t.timestamps
    end
  end
end
