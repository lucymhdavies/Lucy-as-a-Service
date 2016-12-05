
def save_message
	saved_message_text = params['text'].sub(/save */, "")
	saved_message_text = slack_parse saved_message_text


	$redis.setex( "laas:saved_message:#{params['user_id']}", 60 * 30, saved_message_text )

	"Insecurely Saved:\n\n" + saved_message_text
end

def replay_message
	r = $redis.get( "laas:saved_message:#{params['user_id']}" )

	if r.nil? || r == ""
		return slack_secret_message "No saved message for you"
	end

	message = r

	# if invoked with /laas replay standup.*
	# trigger /laas standup next
	if params['text'].start_with?("replay standup")
		task = Thread.new {
			sleep(2)
			post_data = standup_next
			RestClient.post(params['response_url'], post_data )
		}
	end

	slack_message message
end
