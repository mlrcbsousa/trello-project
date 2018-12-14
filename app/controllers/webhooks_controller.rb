# app/controllers/webhooks_controller.rb
class WebhooksController < ActionController::Base
  # skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def complete
    return head :ok
  end

  def receive
  end

  # def update_card(payload)
  #   # TODO: handle updateCard webhook payload
  # end

  # def webhook_secret
  #   ENV['TRELLO_SECRET'] # From https://trello.com/app-key
  # end
end
