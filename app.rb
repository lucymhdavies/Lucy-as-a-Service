require 'sinatra'
require 'dotenv'
require 'json'
require 'sinatra/json'

Dotenv.load

# TODO: Refactor the balls out of this
# My current thinking is:
# - Have a directory, e.g. 'commands', in which all command code is stored
# -- e.g. coffee_roulette
# - Have a hash for which commands are available
# -- Interact with this through a Class, e.g.
# -- LAAS.Commands.register()
# -- This should define:
# --- command name
# --- help text
# --- output method (stdout/stderr = default (in_channel, secret), or by specifying pair)
# -- Maybe each command should be it's own class


# TODO: Avatar (square)
# i.e. just pick it from gravatar

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
	"Yo"
end

get '/slack-slash' do
	"Yo. You probably meant to POST to this URL, right?"
end

# TODO: Verify Slack auth token
# Wrapper for the main /laas slash command
post '/slack-slash' do

	# Hacky logger
	warn params.inspect

	begin
		# TODO: pick these from a hash
		case params['text'].split.first
		when ""
			slack_secret_message "Yo"
		when "help"
			slack_secret_message help
		when "iou"
			slack_secret_message iou
		when "quote"
			slack_message quote
		when "getRandomNumber"
			slack_message xkcd221
		when "teaflick"
			slack_message teaflick
		when "save"
			slack_secret_message save_message
		when "replay"
			slack_message replay_message
		when "lunch_roulette"
			slack_message lunch_roulette
		when "coffee", "coffee_roulette"
			slack_message coffee_roulette
		when "summon"
			slack_message summon
		else
			slack_secret_message "I don't know what to do with: #{params['text'].split.first}"
		end
	rescue Exception => e
		# TODO: is user is lucy, do e.backtrace.inspect
		slack_secret_message "Error!\n" + e.message
	end

end

# Parse a string for slacky things
def slack_parse( text )

	jira_url = ENV['JIRA_URL'] || "https://jira.example.com/"

	# JIRA ticket match
	# TODO: ensure this isn't part of another word
	text = text.gsub( /\p{Alpha}+-\p{Digit}+/ , "<#{jira_url}browse/\\0|\\0>" )

	# Usernames are @bob --> <@bob|bob>
	# TODO: ensure this isn't part of another word or email address or something.
	text = text.gsub( /(@)([a-z0-9][a-z0-9._-]*)/ , "<@\\2|\\2>" )

	# TODO: Detect #channels
	# Channels are <#C024BE7LR|general> (but there must be a way of doing this without knowing the channel id...)

	text
end

# TODO: store this in a db of some sort
$user_vars = {}
def save_message
	saved_message_text = params['text'].sub(/save */, "")
	saved_message_text = slack_parse saved_message_text


	$user_vars[params['user_id']] = { :saved_message => saved_message_text }

	"Insecurely Saved:\n\n" + $user_vars[params['user_id']][:saved_message]
end

def replay_message
	$user_vars[params['user_id']][:saved_message]
end

def xkcd221
	4 # chosen by fair dice roll.
	  # guaranteed to be random
end

# TODO: command to store message, command to playback message

def iou
	"Not implemented"

	# TODO
	# Store a hash of Lucy's usernames on each Slack instance
	# If user is Lucy, then she can say, e.g.:
	# /laas iou @dave 3.00 GBP <reason>
	#
	# No special command to clear an IOU, just:
	# /lass iou @dave 0.00 GBP
	#
	# Then if @dave runs the command
	# /laas iou
	#
	# then it should secret_message:
	# @lucy owes you 3.00 GBP for <reason>
	#
	# Depends on DB
end

def summon
	summon_item = params['text'].sub(/summon */, "")

	# TODO: Use slack emoji API to see if such an emoji exists
	if summon_item != ""
		":#{summon_item}:"
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

# TODO: Pick these from a DB
def coffee_roulette
	coffee_pods = [
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

# TODO: Pick these from a DB
def lunch_roulette
	choices = [
		"M&S",
		"Oisoi",
		"Smokes!",
		"Sainsburys", "Tesco",
		"Edo Sushi",
		"Burger King", "KFC", "Subway"
	]

	choices.sample
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


get '/latest/quote' do
	quote
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
