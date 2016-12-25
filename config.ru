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

run Sinatra::Application
