require 'trello'

Trello.configure do |config|
  config.consumer_key = ENV['TRELLO_KEY']
  config.consumer_secret = ENV['TRELLO_SECRET']
  config.oauth_token = User.first.token
  config.oauth_token_secret = User.first.secret
end
"https://api.trello.com/1/members/#{member.trello_ext_id}?fields=name,url&key=#{ENV['TRELLO_KEY']}&token=#{user.token}"
# toget all the classes in a module
# Trello.constants.select { |c| Trello.const_get(c).is_a? Class }

# all the classes from the command above, part of the Trello module in the ruby-trello gem

trello_module_classes = [
  :List,
  :Error,
  :Action,
  :Request,
  :ConfigurationError,
  :Configuration,
  :Label,
  :Comment,
  :Client,
  :Token,
  :Attachment,
  :Association,
  :AssociationProxy,
  :CoverImage,
  :BasicData,
  :Board,
  :Card,
  :Checklist,
  :CustomField,
  :CustomFieldItem,
  :CustomFieldOption,
  :Item,
  :CheckItemState,
  :LabelName,
  :Member,
  :MultiAssociation,
  :Notification,
  :Organization,
  :PluginDatum,
  :TInternet,
  :Webhook,
  :InvalidAccessToken
]
