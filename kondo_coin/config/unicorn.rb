working_directory "/home/kondocoin/kondocoin/kondo_coin"
pid "/home/kondocoin/tmp/pids/unicorn.pid"
stderr_path "/home/kondocoin/log/unicorn.log"
stdout_path "/home/kondocoin/log/unicorn.log"
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true
check_client_connection false

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

listen "/tmp/unicorn.todo.sock"
worker_processes 2
timeout 30
