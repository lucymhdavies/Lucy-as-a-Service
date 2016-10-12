
def standup_participants
	# TODO, use Slack API to get active users in current channel, sort by first name
	# Useful params:
	# params['channel_id']
	# params['channel_name']
	#
	# Slack API: channels.info: https://api.slack.com/methods/channels.info
	# Values:
	#	channel.menbers is array of member user IDs.
	#
	# Slack API: users.info: https://api.slack.com/methods/users.info
	# Values:
	#	user.name is the username
	#	user.profile.real_name is the full name
	#
	# Slack API: users.getPresence: https://api.slack.com/methods/users.getPresence
	# Values:
	#	presence is either active or away
	# There are other fields, but this is probably the most useful

	# Get participants in this channel
	$standup_participants = [
		"daviesl",
		"dolan-duck",
		"maccky-moose"
	]
	# TODO: exclude some people from this list
end

def standup
	if params['text'].chomp == "standup next"
		slack_message standup_next
	elsif (params['text'].chomp == "standup") || (params['text'].chomp == "standup start")
		slack_message standup_start
	else
		slack_secret_message "I don't know what to do with: #{params['text'].chomp}"
	end
end

# TODO: allow per-channel standups
$standup_participants = []
$standup_over = false
def standup_start
	text = "<!here>: Standup time!\n\n"
	text = text + "Running Order:"

	# Get participants of this standup
	standup_participants

	# Standup has not finished yet
	$standup_over = false

	$standup_participants.each do |p|
		text = text + "\n<@#{p}|#{p}>"
	end

	text
end

def standup_next

	# Is the standup already over?
	if $standup_over
		# Let user start the next standup with standup_next, if they wish
		$standup_over = false
		return "Standup already over! Did you want to start a new one?"
	end

	# Was this standup started with "standup next"?
	if $standup_participants.empty?
		standup_participants
	end

	p = $standup_participants.shift
	pt = "<@#{p}|#{p}>"

	up_next = [
		"You're up #{pt}",
		"#{pt}: go go go!",
		"#{pt} your turn",
		"Achtung #{pt}!"
	]

	# Last person
	if $standup_participants.empty?
		up_next = [
			"Finally, #{pt}",
			"And last, but by no means least, #{pt}"
		]
		$standup_over = true
	end

	up_next.sample
end
