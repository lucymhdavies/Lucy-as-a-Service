
def delay
	warn "Delayed message test"

	task = Thread.new {
		warn "sleeping for 2 secs"
		sleep(2)
		post_data = slack_secret_message( "Second message" )
		warn "Posting to #{params['response_url']}, #{post_data}"
		RestClient.post(params['response_url'], post_data )
	}

	slack_secret_message "First message"
end
