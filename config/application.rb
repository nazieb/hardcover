require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hardcover
  class Application < Rails::Application
    config.domain = "hardcover.xing.hh"
    config.cache_store = :memory_store
  end
end
