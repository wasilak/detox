Detox::Application.configure do
  begin
    APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
  rescue Errno::ENOENT
    APP_CONFIG = false
  end

  print "* Loading config\t" + (APP_CONFIG ? "[ \033[32mSUCCESS\033[0m ]" : "[ \033[31mFAILURE\033[0m ]") + "\n"

  unless APP_CONFIG
    print "\033[36mNo config file found. Please copy config/config.yml.example to config/config.yml.\033[0m\n"
    exit
  end

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.growl = false
    Bullet.rails_logger = true
  end

  config.i18n.default_locale = APP_CONFIG['locale']

  config.eager_load = false
end
