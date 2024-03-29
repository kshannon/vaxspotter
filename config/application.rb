require_relative "boot"

require "rails/all"
require 'csv'
require 'json'
require 'net/http'
require 'date'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Vaxspotter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Pacific Time (US & Canada)"
    config.active_record.default_timezone = :utc # Or :local
    # config.eager_load_paths << Rails.root.join("extras")
    config.i18n.available_locales = [:en, :es]
    config.i18n.default_locale = :en
  end
end
