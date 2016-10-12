
def slack_message ( text )
	json ({
		"response_type" => "in_channel",
		"text"          => text
	})
end

def slack_secret_message ( text )
	json ({
		"text"          => text
	})
end

# Parse a string for slacky things
def slack_parse( text )

	jira_url = ENV['JIRA_URL'] || "https://jira.example.com/"

	# JIRA ticket match
	# TODO: ensure this isn't part of another word
	text = text.gsub( /\p{Alpha}+-\p{Digit}+/ , "<#{jira_url}browse/\\0|\\0>" )

	# Usernames are @bob --> <@bob|bob>
	# TODO: ensure this isn't part of another word or email address or something.
	text = text.gsub( /(@)([a-z0-9][a-z0-9._-]*)/ , "<@\\2|\\2>" )

	# TODO: Detect #channels
	# Channels are <#C024BE7LR|general> (but there must be a way of doing this without knowing the channel id...)

	text
end
