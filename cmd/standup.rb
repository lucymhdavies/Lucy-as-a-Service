
# TODO: populate this on a cron, or with some other command
$all_users = []
def populate_all_users
	if $all_users.empty?
		channel_info = Slack.channels_info( :channel => params['channel_id'] )
		users = channel_info['channel']['members']

		# TODO: exclude some people from this list

		users.each do |uid|
			presence = Slack.users_getPresence( :user => uid )['presence']

			if presence == "active"
				user = Slack.users_info( :user => uid )
				$all_users.push user
			end
		end
	end
end

def standup_participants
	populate_all_users

	# TODO: Sort by real_name

	$standup_participants = []
	# Extract just the usernames
	$all_users.sort! do |a,b|
		a['user']['real_name'] <=> b['user']['real_name']
	end
	$all_users.each do |user|
		$standup_participants.push user['user']
	end
end

def standup
	# TODO: allow slack delayed response for this
	case params['text'].chomp
	when "standup next"
		slack_message standup_next
	when "standup", "standup start"
		# TODO: allow user to specify sort orders
		slack_message standup_start
	when "standup clear", "standup reset"
		$all_users = []
		slack_secret_message "Reset"
	when "standup populate"
		populate_all_users
		slack_secret_message "Populated"
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
# 		text = text + "\n<@#{p}|#{p}>"
		text = text + "\n#{p['real_name']}"
	end

	text = text + "\n\n"
	text = text + "Use `/laas standup next` to summon the next person in the list"
	text = text + "\n\n"

	# summon first user
	text = text + standup_next

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
	#pt = "<@#{p}|#{p}>"
	pt = p['real_name'] # for testing, don't summon people

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
