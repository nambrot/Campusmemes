worker_processes 2 # amount of unicorn workers to spin up
timeout 300000

@resque_pid = nil

before_fork do |server, worker|
  @resque_pid ||= spawn("bundle exec rake jobs:work")
  puts "#{@resque_pid} is worker"
end