pidfile "/home/covid/shared/pids/puma.pid"
threads 0, 16
bind "unix:///tmp/covid.sock"
workers 2

on_worker_boot do
  puts "Starting puma server for covid..."
end
