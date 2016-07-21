require 'sinatra'
require 'dotenv'
require 'json'

Dotenv.load


def slack_message ( text )
	JSON.generate( { "text" => text } )
end


get '/' do
	slack_message "Yo"
end


# TODO: Random from DB?
get '/latest/quote' do
	quotes = [
		"Lucy. But as a service",
		"Morry found Ug Hill"
	]

	slack_message quotes
end

# TODO: Avatar (square)
# i.e. just pick it from gravatar


set(:probability) { |value| condition { rand <= value } }
get '/latest/teaflick', :probability => 0.5 do
	coin = [
		"Heads!",
		"Tails!"
	]

	slack_message coin.sample
end

get '/latest/teaflick' do
	slack_message "It fell on the floor"
end
