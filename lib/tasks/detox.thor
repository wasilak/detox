class Detox < Thor

  desc "deploy", "deploy application"
  def deploy restart = true
    puts "* pulling changes from \033[36mgit\033[0m"
    exec('git pull')
    puts "* cleaning \033[36massets\033[0m"
    exec('bundle exec rake assets:clean')
    puts "* precompiling \033[36massets\033[0m"
    exec('bundle exec rake assets:precompile')
    if restart
        puts "* restarting \033[36mapplication\033[0m"
        exec('touch tmp/restart.txt')
    end
  end
end