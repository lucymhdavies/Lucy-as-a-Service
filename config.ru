require 'rubygems'
require 'bundler'
require 'sinatra'
require 'dotenv'
require 'json'
require 'sinatra/json'
require 'slack'
require 'rest-client'
require "redis"

Bundler.require

Dotenv.load

$redis = Redis.new(:url => ENV["REDIS_URI"])

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
