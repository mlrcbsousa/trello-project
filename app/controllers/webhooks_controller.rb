# app/controllers/webhooks_controller.rb
class WebhooksController < ActionController::Base
  # skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def complete
    return head :ok
  end

  def receive
    # identify webhook
    # parse information to act on
    byebug
  end

  def webhook_params
    params.permit("model", "event", "controller", "action", "webhook")
  end
end
