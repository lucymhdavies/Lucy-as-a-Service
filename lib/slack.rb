
def user_is_admin?( team_id, user_id )
	logger.debug(__method__){ "Is #{user_id}@#{team_id} an admin of this LaaS instance?" }

	admins = $redis.smembers("laas:config:#{team_id}:admins")
	if admins.nil? || admins == ""
		# No admins, trivially the user is not an admin
		logger.warn(__method__){ "No admins defined for team #{team_id}. laas:config:#{team_id}:admins == '#{admins.inspect}'" }
		return false
	end

	logger.debug(__method__){ "Admins: #{admins.inspect}" }

	return admins.include? user_id
end

def from_slack?( team_id, token )
	logger.debug(__method__){ "Checking if Slack token is valid for this team" }
	# i.e. did this request really come from Slack?

	r = $redis.get( "laas:config:#{team_id}:token_from_slack" )
	if r.nil? || r == ""
		logger.warn(__method__){ "No token_from_slack defined for team #{team_id}. laas:config:#{team_id}:token_from_slack == '#{r.inspect}'" }
		return false
	end

	# TODO: Disable for LaaS Develop (in config.ru)
	if r == token
		return true
	else
		logger.error(__method__){ "Invalid token_from_slack for team #{team_id}!" }
		return false
	end
end


def slack_message ( text )
	json ({
		"response_type" => "in_channel",
		"text"          => text
	})
end

def slack_message_as! ( text, uid, channel )
	message_text = ERB::Util.url_encode(text)
	user = Slack.users_info( :user => uid )
	username = ERB::Util.url_encode(user['user']['real_name'])
	icon_url = ERB::Util.url_encode(user['user']['profile']['image_192'])

	post_url = "https://slack.com/api/chat.postMessage?" +
		"token=#{ENV["SLACK_API_TOKEN"]}" +
		"&channel=#{channel}" +
		"&username=#{username}" +
		"&icon_url=#{icon_url}" +
		"&as_user=false" +
		"&text=#{message_text}"

	RestClient.get(post_url)
end

def slack_secret_message ( text )
	json ({
		"text"          => text
	})
end

# Parse a string for slacky things
def slack_parse( team_id, text )
	jira_url = $redis.get( "laas:config:#{team_id}:jira_url" )
	if jira_url.nil? || jira_url == ""
		logger.warn(__method__){ "No jira_url defined for team #{team_id}. laas:config:#{team_id}:jira_url == '#{jira_url.inspect}'" }
		jira_url = "https://jira.example.com/"
	end

	# JIRA ticket match
	# TODO: ensure this isn't part of another word
	text = text.gsub( /\p{Alpha}+-\p{Digit}+/ , "<#{jira_url}browse/\\0|\\0>" )

	# Usernames are @bob --> <@bob|bob>
	# TODO: ensure this isn't part of another word or email address or something.
	# No longer supported, but leaving the comment here for now
	# text = text.gsub( /(@)([a-z0-9][a-z0-9._-]*)/ , "<@\\2|\\2>" )

	# TODO: Detect #channels
	# Channels are <#C024BE7LR|general> (but there must be a way of doing this without knowing the channel id...)

	text
end
