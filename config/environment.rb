RAILS_GEM_VERSION = '2.2.2'

# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
# RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.action_controller.session = {
    :session_key => '_burkert_session',
    :secret      => '971192b51828d97a2e233e44c37d30eeeec2eb3933db48ac0775344e1e6bb31ac36d8c20d20609c5de2af9443dedbdae7af1a22912671daafc63aed154233da2'
  }
end

APP_SETTINGS = YAML.load_file("#{RAILS_ROOT}/config/settings.yml")