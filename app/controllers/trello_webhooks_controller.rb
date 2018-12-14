# app/controllers/trello_webhooks_controller.rb
class TrelloWebhooksController < ActionController::Base
  include TrelloWebhook::Processor

  def update_card(payload)
    # TODO: handle updateCard webhook payload
  end

  def webhook_secret
    ENV['TRELLO_SECRET'] # From https://trello.com/app-key
  end
end