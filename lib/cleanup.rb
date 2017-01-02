require 'logger'
logger = Logger.new(STDOUT)

# Catch SIGTERM and let app kill itself
# Because otherwise, when Heroku kills the app, we get FATAL errors
Signal.trap('TERM') do
  current_pid = Process.pid
  signal      = "SIGINT"
  Process.kill(signal, current_pid)
end

at_exit do
	# Placeholder for any cleanup code needed when app shuts down
	logger.info "Bye"
end
