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

$redis = Redis.new(:url => ENV["REDIS_URI"])

Slack.configure do |config|
    config.token = ENV["SLACK_API_TOKEN"]
end

# Library files
Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }
