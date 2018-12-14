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
  end

  private

  def event_params
    params.require(:event).permit(:id, :idMemberCreator, :data, :type, :date, :limits, :display, :memberCreator)
  end

  def model_params
    params.require(:model).permit(:id, :name, :desc, :descData, :closed, :idOrganization, :pinned, :url, :shortUrl, :prefs, :labelNames)
  end

  def webhook_params
    params.require(:webhook).permit(:model, :event)
  end
end

