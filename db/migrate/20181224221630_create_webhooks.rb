class CreateWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks do |t|
      t.string :ext_board_id

      t.timestamps
    end
  end
end
