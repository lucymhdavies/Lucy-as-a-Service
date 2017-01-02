# Common includes
Dir[File.dirname(__FILE__) + '/lib/includes.rb'].each {|file| require file }

# Commands
Dir[File.dirname(__FILE__) + '/cmd/*.rb'].each {|file| require file }

# Main app file
Dir[File.dirname(__FILE__) + '/app.rb'].each {|file| require file }

# set up log levels
configure :test do
    set :logging, Logger::ERROR
end
configure :development do
    set :logging, Logger::DEBUG

    set(:cookie_options) do
        { :expires => Time.now + 3600 * 24 * 5 }
    end
end
configure :production do
    set :logging, Logger::INFO

    set(:cookie_options) do
        { :expires => Time.now + 3600 * 24 * 5 }
    end
end

# LaaS
map "/" do
	run Sinatra::Application
end

# DB Browser
require "redis-browser"
map "/db" do
	settings = {
		"connections" => {
			"default" => {
				"url" => ENV["REDIS_URI"]
			}
		}
	}

	RedisBrowser.configure(settings)

	RedisBrowser::Web.class_eval do
	  use Rack::Auth::Basic, "Protected Area" do |username, password|
		username == ENV["REDIS_UI_USER"] && password == ENV["REDIS_UI_PASS"]
	  end
	end

	run RedisBrowser::Web

end

# Cleanup task
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
	logger.info("Cleanup") {"Bye"}
end
