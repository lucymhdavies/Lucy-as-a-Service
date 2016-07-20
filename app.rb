require 'sinatra'
require 'dotenv'
require 'json'

Dotenv.load



get '/' do
	JSON.generate( "Yo" )
end


# TODO: Random from DB?
get '/latest/quote' do
	quotes = [
		"Lucy. But as a service",
		"Morry found Ug Hill"
	]

	JSON.generate( quotes.sample )
end

# TODO: Avatar (square)
# i.e. just pick it from gravatar


set(:probability) { |value| condition { rand <= value } }
get '/latest/teaflick', :probability => 0.5 do
	coin = [
		"Heads!",
		"Tails!"
	]

	JSON.generate( coin.sample )
end

get '/latest/teaflick' do
	JSON.generate( "It fell on the floor" )
end
