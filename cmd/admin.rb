def admin
	unless user_is_admin?( params['team_id'], params['user_id'] )
		return slack_secret_message "These commands are for admins only!"
	end

	case params['text'].chomp
	when "admin db", "sudo db"
		slack_secret_message redis_link
	else
		slack_secret_message "I don't know what to do with: #{params['text'].chomp}"
	end
end

def redis_link
	r = $redis.get( "laas:config:redis_admin" )

	if r.nil? || r == ""
		r = request.scheme + "://" + request.host + ":" + request.port.to_s + "/db"
	end

	r

end

def say_message
	unless user_is_admin?( params['team_id'], params['user_id'] )
		return slack_secret_message "These commands are for admins only!"
	end

	task = Thread.new {
		message_text = params['text'].sub(/say */, "")
		message_text = slack_parse( params['team_id'], message_text )
		post_data = slack_message message_text
		RestClient.post(params['response_url'], post_data )
	}

	slack_secret_message "Sent"
end

def me_say_message
	task = Thread.new {
		message_text = params['text'].sub(/isay */, "")
		message_text = slack_parse( params['team_id'], message_text )
		slack_message_as!( message_text, params['user_id'], params['channel_id'] )
	}

	slack_secret_message "Sent"
end
