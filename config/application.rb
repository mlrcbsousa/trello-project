require_relative 'boot'

require 'rails/all'
require_relative '../lib/middlewares/trello_payload_handler.rb'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TrelloProject
  class Application < Rails::Application
    config.generators do |generate|
          generate.assets false
          generate.helper false
          generate.test_framework  :test_unit, fixture: false
        end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # config.web_console.whitelisted_ips = [
    #   '107.23.104.115',
    #   '54.152.166.250',
    #   '107.23.149.70',
    #   '54.164.77.56',
    #   '54.209.149.230'
    # ]
    config.middleware.use TrelloPayloadHandler
  end
end
