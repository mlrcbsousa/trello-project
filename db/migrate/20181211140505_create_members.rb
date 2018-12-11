class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :trello_ext_id, null: false, unique: true
      t.references :sprint, foreign_key: true
      t.boolean :contributor, null: false, default: true
      t.integer :days_per_sprint
      t.integer :total_hours, null: false
      t.integer :hours_per_day, null: false, default: 8
      t.timestamps
    end
  end
end