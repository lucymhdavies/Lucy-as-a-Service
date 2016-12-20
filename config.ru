# Common includes
Dir[File.dirname(__FILE__) + '/lib/includes.rb'].each {|file| require file }

# Commands
Dir[File.dirname(__FILE__) + '/cmd/*.rb'].each {|file| require file }

# Main app file
Dir[File.dirname(__FILE__) + '/app.rb'].each {|file| require file }

run Sinatra::Application
