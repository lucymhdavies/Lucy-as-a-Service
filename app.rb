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

def slack_secret_message ( text )
	json ({
		"text"          => text
	})
end


get '/' do
	slack_message "Yo"
end


# Wrapper for the main /laas slash command
post '/slack-slash' do

	# Hacky logger
	warn params.inspect

	case params['text']
	when ""
		slack_secret_message "Yo"
	when "quote"
		slack_message quote
	when "help"
		slack_secret_message "Sorry. Can't help you (yet)"
	else
		slack_secret_message "Coming soon!"
	end

end

def quote
	quotes = [
		"Lucy. But as a service",
		"Morry found Ug Hill",
		"I remembered [the postcode] because it has 'BJ' in it. And I'm 13 years old and amused by such things.",
		"Like!\nSubscribe!\nFollow on Twitter!\nAll that good stuff."
	]

	quotes.sample
end


# TODO: Random from DB?
get '/latest/quote' do
	quote
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
