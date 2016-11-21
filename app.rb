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
			replay_message
		when "lunch_roulette"
			slack_message lunch_roulette
		when "coffee", "coffee_roulette"
			slack_message coffee_roulette
		when "noodle", "noodle_roulette"
			slack_message noodle_roulette
		when "standup"
			standup
		when "summon"
			slack_message summon
		when "delay"
			delay
		when "smeg"
			slack_message red_dwarf_quote
		else
			slack_secret_message "I don't know what to do with: #{params['text'].split.first}"
		end
	rescue Exception => e
		if params['user_name'] == "daviesl"
			slack_secret_message "Error!\n\n\`\`\`" + e.backtrace.inspect + "\n\`\`\`"
		else
			slack_secret_message "Error!\n" + e.message
		end
	end

end

