class CreateBoards < ActiveRecord::Migration[5.2]
  def change
    create_table :boards do |t|
      t.string :trello_ext_id
      t.references :user, foreign_key: true
      t.string :background_url

      t.timestamps
    end
  end
end
