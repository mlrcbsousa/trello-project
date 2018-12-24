class AddWebhookReferenceToSprints < ActiveRecord::Migration[5.2]
  def change
    add_reference :sprints, :webhook, foreign_key: true
  end
end
