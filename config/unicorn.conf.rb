# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes 8

homedir = ENV['HOME']
username = ENV['USER']
groupname = `id -gn #{username}`.strip # OSX doesn't follow unix convention of gn=un here.

#working_directory "#{homedir}/src/pikimal/current" # available in 0.94.0+

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
#listen "/tmp/.sock", :backlog => 64
listen 3000, :tcp_nopush => true

timeout 600

pid "#{homedir}/src/pikimal/shared/pids/unicorn.pid"

# some applications/frameworks log to stderr or stdout, so prevent
# them from going to /dev/null when daemonized here:
#stderr_path "#{homedir}/src/pikimal/log/unicorn.stderr.log"
#stdout_path "#{homedir}/src/pikimal/log/unicorn.stdout.log"

# combine REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  old_pid =  '#{homedir}/pikimal/shared/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH => e
      # someone else did our job for us
      STDERR.puts "begin/rescue, #{e.message}"
    end
  else 
    STDERR.puts "if was false. File.exists?(old_pid) (#{File.exists?(old_pid)}) && server.pid != old_pid (#{server.pid != old_pid})"
  end

end

after_fork do |server, worker|

  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  begin
    uid, gid = Process.euid, Process.egid
    user, group = username, groupname
    target_uid = Etc.getpwnam(user).uid
    target_gid = Etc.getgrnam(group).gid
    worker.tmp.chown(target_uid, target_gid)
    if uid != target_uid || gid != target_gid
      Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end
  rescue => e
    if RAILS_ENV == 'development'
      STDERR.puts "couldn't change user, oh well"
    else
      raise e
    end
  end

end
