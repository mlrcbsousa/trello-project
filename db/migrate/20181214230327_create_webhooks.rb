class CreateWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks do |t|
      t.references :sprint, foreign_key: true
      t.string :description
      t.boolean :active
      t.string :trello_ext_id
      t.string :callback_url

      t.timestamps
    end
  end
end
