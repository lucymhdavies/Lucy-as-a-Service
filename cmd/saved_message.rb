
# TODO: store this in a db of some sort
$user_vars = {}
def save_message
	saved_message_text = params['text'].sub(/save */, "")
	saved_message_text = slack_parse saved_message_text


	$user_vars[params['user_id']] = { :saved_message => saved_message_text }

	"Insecurely Saved:\n\n" + $user_vars[params['user_id']][:saved_message]
end

def replay_message
	# if invoked with /laas replay standup.*
	# trigger /laas standup next
	if params['text'].start_with?("replay standup") {
		task = Thread.new {
			post_data = standup_next
			sleep(2)
			RestClient.post(params['response_url'], post_data )
		}
	}

	$user_vars[params['user_id']][:saved_message]
end
