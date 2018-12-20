class CreateWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks do |t|
      t.references :user, foreign_key: true
      t.string :description
      t.string :ext_board_id

      t.timestamps
    end
  end
end
