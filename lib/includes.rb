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

Slack.configure do |config|
    config.token = ENV["SLACK_API_TOKEN"]
end

# Library files
Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }
