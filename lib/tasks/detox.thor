class Detox < Thor

  desc "deploy", "deploy application"
  def deploy restart = true
    puts "* pulling changes from \033[36mgit\033[0m"
    system('git pull')
    puts "* executing \033[36mbundle install\033[0m"
    system('bundle install')
    puts "* performing \033[36mDB migrations\033[0m"
    system('bundle exec rake db:migrate')
    puts "* cleaning \033[36massets\033[0m"
    system('bundle exec rake assets:clobber')
    puts "* precompiling \033[36massets\033[0m"
    system('bundle exec rake assets:precompile')
    if restart
        puts "* restarting \033[36mapplication\033[0m"
        system('touch tmp/restart.txt')
    end
  end
end