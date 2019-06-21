require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AlphaBetApi

  class Application < Rails::Application

    config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '*',
      :headers => :any,
      :expose  => ['access-token', 'expiry', 'token-type', 'uid', 'client'],
      :methods => [:get, :post, :put, :delete, :destroy, :options]

    end
  end

  end

end
