worker_processes 2 # amount of unicorn workers to spin up
timeout 300000

@resque_pid = nil
@resque_pid2 = nil
before_fork do |server, worker|
  @resque_pid ||= spawn("bundle exec rake jobs:work")
  @resque_pid2 ||= spawn("bundle exec clockwork app/clock.rb")
end