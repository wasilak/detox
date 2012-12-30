# loading config for app. presence of file already checked in application.rb
APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]