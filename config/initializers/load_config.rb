begin
  APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
rescue Errno::ENOENT
  APP_CONFIG = false
end

print APP_CONFIG.inspect

print "* Loading config\t" + (APP_CONFIG ? "[ \033[32mSUCCESS\033[0m ]" : "[ \033[31mFAILURE\033[0m ]") + "\n"

unless APP_CONFIG
  print "\033[36mNo config file found. Please copy config/config.yml.example to config/config.yml.\033[0m\n"
  exit
end