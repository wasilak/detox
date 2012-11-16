Airbrake.configure do |config|
  config.api_key = 'be7224cb8cb6888d531728be00794841'
  config.host    = 'bugs.wasil.org'
  config.port    = 80
  config.secure  = config.port == 443
  # config.development_environments = []
end
