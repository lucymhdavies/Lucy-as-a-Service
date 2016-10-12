
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
