app_dir = "/var/www/apps/petrovsky_house_production"

# Set unicorn options
worker_processes 4
preload_app true
timeout 60
pid "#{app_dir}/shared/pids/unicorn.pid"
listen "#{app_dir}/shared/pids/unicorn.sock", :backlog => 64

stderr_path "#{app_dir}/shared/log/unicorn_err.log"
stdout_path "#{app_dir}/shared/log/unicorn_out.log"

before_fork do |server, worker|
  old_pid = "#{app_dir}/shared/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
