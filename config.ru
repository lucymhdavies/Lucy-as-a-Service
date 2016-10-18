require 'rubygems'
require 'bundler'
require 'sinatra'
require 'dotenv'
require 'json'
require 'sinatra/json'
require 'slack'
require 'rest-client'
Bundler.require

Dotenv.load

# Library files
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

# Commands
Dir[File.dirname(__FILE__) + '/cmd/*.rb'].each {|file| require file }

Slack.configure do |config|
    config.token = ENV["SLACK_API_TOKEN"]
end

# Main app file
require './app.rb'

run Sinatra::Application
