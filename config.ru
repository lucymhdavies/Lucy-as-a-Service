require 'rubygems'
require 'bundler'
require 'sinatra'
Bundler.require

require './app.rb'
run Sinatra::Application
