class CreateSprints < ActiveRecord::Migration[5.2]
  def change
    create_table :sprints do |t|
      t.string :trello_ext_id, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :man_hours, default: 0
      t.references :user, foreign_key: true
      t.string :trello_url

      t.timestamps
    end
  end
end
