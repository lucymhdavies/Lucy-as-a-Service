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
	when "help"
		slack_secret_message help
	when "quote"
		slack_message quote
	when "teaflick"
		slack_message teaflick
	when "coffee_roulette"
		slack_message coffee_roulette
	else
		slack_secret_message "Coming soon!"
	end

end

def help
	[
		"Proper help coming later. For now, commands available:",
		"\thelp - show this message",
		"\tquote - show a random quote",
		"\tteaflick - Teaflick!",
		"\tcoffee_roulette - Pick one of the SHF coffee pods for you at random"
	].join("\n")
end

def coffee_roulette
	coffee_pods = [
		["Espresso Decaffeinato", "Lungo Decaffeinato"],
		["Lungo Origin Guatamala", "Lungo Forte"],
		["Espresso Forte", "Espresso Leggero", "Espresso Origin Brazil"],
		["Ristretto", "Ristretto Origin India", "Ristretto Intenso"]
	]
	coffee_styles = [
		["Espresso", "Espresso, with Milk", "Espresso Mocha"],
		["Americano", "Americano, with Milk"],
		["Latte"],
		["Mocha"]
	]

	["'" + coffee_pods.sample.sample + "'", "Pod,", coffee_styles.sample.sample].join(" ")
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

get "/test" do
	slack_message help
end

def teaflick
	if rand < 0.1
		coin_side = "It fell on the floor!"
	else
		coin_side = ["Heads!", "Tails!"].sample
	end

	at_user = ""
	unless params['user_name'].nil?
		at_user = "<@#{params['user_id']}|#{params['user_name']}>: "
	end

	at_user + coin_side
end

get '/latest/teaflick' do
	teaflick
end
