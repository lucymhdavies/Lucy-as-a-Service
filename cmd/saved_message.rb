
# TODO: store this in a db of some sort
$user_vars = {}
def save_message
	saved_message_text = params['text'].sub(/save */, "")
	saved_message_text = slack_parse saved_message_text


	$user_vars[params['user_id']] = { :saved_message => saved_message_text }

	slack_secret_message "Insecurely Saved:\n\n" + $user_vars[params['user_id']][:saved_message]
end

def replay_message(user_id = nil, from = nil)
	# Messages come from the user who invoked the command if unspecified
	user_id ||= params['user_id']

	#if $user_vars[user_id] != nil && $user_vars[user_id][:saved_message] != nil
	if $user_vars[user_id] != nil && $user_vars[user_id][:saved_message] != nil

		# if invoked with /laas replay standup.*
		# trigger /laas standup next
		if params['text'].start_with?("replay standup") || from == :standup_next
			task = Thread.new {
				sleep(2)
				post_data = standup_next
				RestClient.post(params['response_url'], post_data )
			}
		end

		text = $user_vars[user_id][:saved_message]

		user = Slack.users_info( :user => user_id )
		user_icon = user['user']['profile']['image_48']
		username  = user['user']['profile']['real_name'] || userinfo['user']['name']

		message = json ({
			"response_type" => "in_channel",
			"text"          => text,
			"username"      => username,
			"icon_url"      => user_icon
		})

		warn "Message:"
		warn message

		message
	else
		slack_secret_message "No saved message for you"
	end
end

# TODO:
# def has_saved_message( user_id )
# Or, for that matter, do this in a Class
