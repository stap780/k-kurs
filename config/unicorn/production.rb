working_directory '/var/www/kurs/current'
pid '/var/www/kurs/current/tmp/pids/unicorn.pid'
stderr_path '/var/www/kurs/log/unicorn.log'
stdout_path '/var/www/kurs/log/unicorn.log'
listen '/tmp/unicorn.kurs.sock'
worker_processes 12
timeout 30

before_fork do |server, worker|
  old_pid = "/var/www/kurs/current/tmp/pids/unicorn.pid.oldbin"
  if old_pid != server.pid
    begin
    sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
    Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
