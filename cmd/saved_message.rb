
def save_message
	saved_message_text = params['text'].sub(/save */, "")

	task = Thread.new {
		saved_message_text = slack_parse( params['team_id'], saved_message_text )

		$redis.setex( "laas:saved_message:#{params['user_id']}", 60 * 30, saved_message_text )

		message_text = "Insecurely Saved:\n\n" + saved_message_text

		post_data = slack_secret_message message_text
		RestClient.post(params['response_url'], post_data )
	}

	slack_secret_message "Saving message..."
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
			sleep(1)
			slack_message_as!( message, params['user_id'], params['channel_id'] )

			sleep(2)
			post_data = standup_next
			RestClient.post(params['response_url'], post_data )
		}
		# TODO: check if LaaS has permission to post directly to this channel
		# If not, replay the message as LaaS instead
		slack_message "Acquiring saved standup message, on behalf of #{params['user_name']}..."
	else
		slack_message message
	end

end

