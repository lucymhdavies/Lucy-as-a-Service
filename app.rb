require 'sinatra'
require 'dotenv'

Dotenv.load



get '/' do
	"Hello Sinatra"
end


