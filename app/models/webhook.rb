class Webhook < ApplicationRecord
  belongs_to :user

  # "1c61295855f06e92d654032e99d6e21c2ea7a02fa3d03436dc96bec416764002" user token
  # "53c20b4f69afa1271b0fc0fff9f859b3" app api key

  # view all webhooks
  # https://api.trello.com/1/tokens/1c61295855f06e92d654032e99d6e21c2ea7a02fa3d03436dc96bec416764002/webhooks/?key=53c20b4f69afa1271b0fc0fff9f859b3

  def post(sprint)
    HTTParty.post(
      "https://api.trello.com/1/tokens/#{user.token}/webhooks/?key=#{ENV['TRELLO_KEY']}",
      query: {
        description: "Sprint webhook user#{user.id}",
        callbackURL: "#{ENV['BASE_URL']}webhooks",
        idModel: sprint.trello_ext_id
      },
      headers: { "Content-Type" => "application/json" }
    )
  end
end
