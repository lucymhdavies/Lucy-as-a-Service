require 'sinatra'
require 'dotenv'
require 'json'
require 'sinatra/json'

Dotenv.load


def slack_message ( text )
	json ({
		"response_type" => "in_channel",
		"text"          => text
	})
end


get '/' do
	slack_message "Yo"
end


# TODO: Random from DB?
get '/latest/quote' do
	quotes = [
		"Lucy. But as a service",
		"Morry found Ug Hill",
		"I remembered [the postcode] because it has 'BJ' in it. And I’m 13 years old and amused by such things."
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

	at_user = ""
	unless params['user_name'].nil?
		at_user = "<@#{params['user_id']}|#{params['user_name']}>: "
	end

	slack_message at_user + coin.sample
end

get '/latest/teaflick' do
	at_user = ""
	unless params['user_name'].nil?
		at_user = "<@#{params['user_id']}|#{params['user_name']}>: "
	end

	slack_message at_user + "It fell on the floor!"
end
