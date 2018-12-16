class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :trello_ext_id, null: false
      t.references :sprint, foreign_key: true
      t.boolean :contributor, default: true
      t.integer :days_per_sprint
      t.integer :available_hours, null: false, default: 0
      t.integer :hours_per_day, null: false, default: 8
      t.timestamps
    end
  end
end
