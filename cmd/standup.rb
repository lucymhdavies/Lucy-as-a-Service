
$all_users = []
def populate_all_users
	if $all_users.empty?
		channel_info = Slack.channels_info( :channel => params['channel_id'] )

		if channel_info['ok']
			users = channel_info['channel']['members']
		else
			# If channel not found, maybe it's a private channel?
			# https://api.slack.com/methods/groups.info
			channel_info = Slack.groups_info( :channel => params['channel_id'] )

			if channel_info['ok']
				users = channel_info['group']['members']
			else
				fail "No such channel"
			end
		end


		$exclude_users = []
		unless ENV['EXCLUDED_STANDUP_USERS'].nil?
			$exclude_users = ENV['EXCLUDED_STANDUP_USERS'].split(",")
		end

		all_users_local = []
		users.each do |uid|
			presence = Slack.users_getPresence( :user => uid )['presence']

			if presence == "active"
				user = Slack.users_info( :user => uid )

				unless $exclude_users.include? user['user']['name']
					all_users_local.push user
				end
			end
		end
		if $all_users.empty?
			$all_users = all_users_local
		else
			fail "Race condition! Somebody else already started populating the standup!"
		end
	end
end

def standup_participants
	populate_all_users

	$standup_participants = []
	$standup_participants_skipped = []

	# Extract just the usernames
# 	$all_users.sort! do |a,b|
# 		a['user']['real_name'] <=> b['user']['real_name']
# 	end

	$all_users.shuffle!

	$all_users.each do |user|
		$standup_participants.push user['user']
	end

end

def standup
	# TODO: allow slack delayed response for more of this
	case params['text'].chomp
	when "standup next"
		standup_next
	when "standup skip"
		standup_skip
	when "standup", "standup start"
		# TODO: allow user to specify sort orders
		standup_start
	when "standup clear", "standup reset"
		$all_users = []
		slack_secret_message "Reset"
	when "standup done"
		standup_done
	when "standup populate"
		task = Thread.new {
			populate_all_users
			post_data = slack_secret_message "Populated"
			RestClient.post(params['response_url'], post_data )
		}
		slack_secret_message "Populating"
	else
		slack_secret_message "I don't know what to do with: #{params['text'].chomp}"
	end
end

# TODO: allow per-channel standups
$standup_participants = []
$standup_participants_skipped = []
$standup_over = false

def standup_done
	# Let user start the next standup with standup_next, if they wish
	$standup_over = false
	$all_users = []
	message = ":boom: Standup Complete! :boom:"

	unless $standup_participants_skipped.empty?
		message = message + "\n\nSkipped users:\n"

		$standup_participants_skipped.each do |p|
			pt = "<@#{p['name']}|#{p['name']}> - #{p['real_name']}"
			message = message + "#{pt}\n"
		end
	end

	slack_message message
end

def standup_start

	task = Thread.new {
		post_data = slack_message "`/laas standup start`\n\n<!here>: Standup time!"
		sleep(0.1)
		RestClient.post(params['response_url'], post_data )

		second_response = "Running Order (Shuffled):"

		# Get participants of this standup
		standup_participants

		# Standup has not finished yet
		$standup_over = false

		$standup_participants.each do |p|
			pt = "<@#{p['name']}|#{p['name']}> - #{p['real_name']}"
			second_response = second_response + "\n#{pt}"
		end

		post_data = slack_message second_response

		# Sleep a second, to ensure first message has been sent
		# This is kinda a hack. Better would be to push messages into a queue, and
		# start a thread to monitor the queue, sending messages as they arrive.
		# Thread would be terminated when the queue contains an EOM item

		sleep(0.1)
		RestClient.post(params['response_url'], post_data )

		post_data = slack_message "Use `/laas standup next` to summon the next person in the list\nor `/laas standup skip` to skip somebody not present"
		sleep(0.1)
		RestClient.post(params['response_url'], post_data )

		# summon first user
		post_data = standup_next
		sleep(0.1)
		RestClient.post(params['response_url'], post_data )
	}

	slack_secret_message "Initiating Standup"
end

# When did somebody last type /laas standup next?
$last_standup_next = nil
$last_standup_participant = nil
def standup_next
	# Has nobody called standup_next yet?
	# or has nobody called it in the past 2 seconds?
	if $last_standup_next.nil? or ($last_standup_next + 2 < Time.now)
		$last_standup_next = Time.now
	else
		return slack_secret_message "Slow down!"
	end

	# Is the standup already over?
	if $standup_over
		return standup_done
	end

	# Was this standup started with "standup next"?
	if $standup_participants.empty?
		return standup_start
	end

	p = $standup_participants.shift
	$last_standup_participant = p
	pt = "<@#{p['name']}|#{p['name']}>"

	up_next = [
		"You're up #{pt}",
		"#{pt}: go go go!",
		"#{pt} your turn",
		"Go go gadget, #{pt}!",
		":partyparrot: summons #{pt}",
		"It's #{pt} O'Clock!",
		"Something something #{pt}",
		"#{pt}!",
		"A wild #{pt} appeared!",
		"#{pt}, would you kindly...",
		":kermit: Today's special guest on the Muppets show: #{pt}",
		":pokeball: I choose you! #{pt}",
		"Achtung #{pt}!",
		"p = Standup.participants.pop(); p['name'] == #{pt}"
	]

	# Last person
	if $standup_participants.empty?
		up_next = [
			"Finally, #{pt}",
			"Lastly, #{pt}",
			"#{pt}, finish us off!",
			"And for our grand finale, #{pt}!",
			"And last, but by no means least, #{pt}"
		]
		$standup_over = true
		$all_users = []
	end

	slack_message up_next.sample
end

def standup_skip
	$standup_participants_skipped.push $last_standup_participant
	standup_next
end
