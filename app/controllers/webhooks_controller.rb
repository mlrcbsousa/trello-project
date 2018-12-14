# app/controllers/webhooks_controller.rb
class WebhooksController < ActionController::Base

  def update_card(payload)
    # TODO: handle updateCard webhook payload
  end

  def webhook_secret
    ENV['TRELLO_SECRET'] # From https://trello.com/app-key
  end
end
