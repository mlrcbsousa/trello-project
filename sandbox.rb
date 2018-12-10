require 'trello'

Trello.configure do |config|
  config.consumer_key = ENV['TRELLO_KEY']
  config.consumer_secret = ENV['TRELLO_SECRET']
  config.oauth_token = User.first.token
  config.oauth_token_secret = User.first.secret
end

# Trello.constants.select { |c| Trello.const_get(c).is_a? Class }
