require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BodyframeRor
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # config.middleware.use ActionDispatch::Flash
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options], expose: ['access-token', 'expiry', 'token-type', 'uid', 'client']
      end
    end

    #For AWS SES email service
    config.action_mailer.smtp_settings = {
      address: 'email-smtp.us-east-1.amazonaws.com', #ENV['SMTP_ADDRESS'],
      domain: 'mail.matrixm.email', #ENV['BASE_URL'],
      port: 587,
      user_name: ENV["SES_SMTP_USERNAME"],
      password: ENV["SES_SMTP_PASSWORD"],
      authentication: "plain",
      enable_starttls_auto: true
    }

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true
    # Send email in development mode?
    config.action_mailer.perform_deliveries = true

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = false
  end
end
