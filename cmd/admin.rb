def admin
	unless user_is_admin?( params['team_id'], params['user_id'] )
		return slack_secret_message "These commands are for admins only!"
	end

	case params['text'].chomp
	when "admin db"
		slack_secret_message redis_link
	else
		slack_secret_message "I don't know what to do with: #{params['text'].chomp}"
	end
end

def redis_link
	r = $redis.get( "laas:config:redsmin" )

	if r.nil? || r == ""
		return "Sorry. Don't know the DB URL :disappointed:"
	end

	r

end
