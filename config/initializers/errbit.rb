begin
  ERRBIT_CONFIG = YAML.load_file("#{Rails.root}/config/errbit.yml")[Rails.env]
rescue Errno::ENOENT
  ERRBIT_CONFIG = false
end

print "* Loading Errbit config\t" + (ERRBIT_CONFIG ? "[ \033[32mSUCCESS\033[0m ]" : "[ \033[31mFAILURE\033[0m ]") + "\n"

if ERRBIT_CONFIG
  if ERRBIT_CONFIG['enabled']
    print "* Errbit status\t\t[ \033[32mENABLED\033[0m ]\n"
    Airbrake.configure do |config|
      config.api_key = ERRBIT_CONFIG['api_key']
      config.host    = ERRBIT_CONFIG['host']
      config.port    = ERRBIT_CONFIG['port']
      config.secure  = config.port == ERRBIT_CONFIG['secure']
      if ERRBIT_CONFIG['development_environments']
        config.development_environments = []
      end
    end
  else
    print "* Errbit status\t\t[ \033[36mDISABLED\033[0m ]\n"
  end
end

# [AIRBRAKE] config.js_notifier has been deprecated and has no effect.  
# You should use <%= airbrake_javascript_notifier %> directly at the top of your layouts. 
# Be sure to place it before all other javascript.
