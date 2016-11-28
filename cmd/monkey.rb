
def monkey
	# Uncache value at start of request
	$monkey_enabled = nil

	unless can_use_monkey?
		return slack_secret_message "Unable to use Monkey commands in this Slack team. Wait for OAuth"
	end

	unless $monkey_group
		return slack_secret_message "No #{ENV['SLACK_MONKEY_GROUP']} user group!"
	end

	case params['text'].chomp
	when "monkey", "monkey who", "monkeys", "monkeys who"
		monkey_list
	when "monkey me", "monkey set", "monkeys set"
		monkey_me
	when "monkey clear", "monkeys clear"
		monkey_clear
	else
		slack_secret_message "I don't know what to do with: #{params['text'].chomp}"
	end
end

# TODO: change these all to instance variables
$monkey_group = nil
$monkey_enabled = nil
$monkey_group_enabled = nil


def can_use_monkey?
	# If we have already checked, return result of last check
 	if $monkey_enabled != nil
 		return $monkey_enabled
 	end

	# No monkeys until proven otherwise
	$monkey_enabled = false

	# Get all user groups, including disabled
	res = Slack.usergroups_list( {:include_disabled => 1, :include_users => 1} )

	# If we were able to talk to Slack
	# i.e. our API token allows this method
	if res['ok']
		$monkey_enabled = true
	end

	# If we have user groups in the API return...
	if res['usergroups']
		warn "Usergroups:"
		warn res['usergroups'].inspect
	
		# Filter returned usergroups by name
		$monkey_group = res['usergroups'].select do |usergroup|
			usergroup['handle'] == ENV["SLACK_MONKEY_GROUP"]
		end
		$monkey_group = $monkey_group[0]

		warn "Monkey Group:"
		warn $monkey_group

		# If we have a monkey group (enabled or disabled)
		if $monkey_group
			# Get all enabled groups
			res2 = Slack.usergroups_list( {:include_disabled => 0} )
			warn "Enabled Usergroups:"
			warn res2['usergroups']

			# Is the monkey group in the list of enabled groups?
			$monkey_group_enabled = res2['usergroups'].select do |usergroup|
				usergroup['handle'] == ENV["SLACK_MONKEY_GROUP"]
			end
		else
			# There was no monkey group (enabled or disabled)
			$monkey_enabled = false
		end
	else
		# No usergroups in API return
		$monkey_enabled = false
	end

	$monkey_enabled
end

def monkey_group_enabled?
	unless can_use_monkey?
		return slack_secret_message "Unable to use Monkey commands in this Slack team. Wait for OAuth"
	end


	# If there exists an enabled monkey group, return true, else return false
	if $monkey_group_enabled != []
		warn "Monkey group enabled"
		true
	else
		warn "Monkey group disabled"
		false
	end
end


def monkey_list
	if monkey_group_enabled?
		warn "Listing monkeys"

		#slack_secret_message "TODO: List current monkeys. Exclude ps-user"
		message = "Users in @#{ENV['SLACK_MONKEY_GROUP']}:\n\n"

		warn "Monkey Group:"
		warn $monkey_group.inspect

		warn "Iterating through monkey group users"
		$monkey_group['users'].each do |uid|
			warn uid.inspect

			user = Slack.users_info( :user => uid )
			p = user['user']
			warn "p = " + p.inspect

			pt = "<@#{p['name']}|#{p['name']}> - #{p['real_name']}"
			message += "#{pt}\n"
		end

		slack_message message
	else
		slack_message "No users in @#{ENV['SLACK_MONKEY_GROUP']} at the moment. Why not add yourself with `/laas monkey me`?"
	end
end


# TODO
def monkey_me
	slack_secret_message "TODO: Add me to today's monkey group, then list monkeys"
	# https://api.slack.com/methods/usergroups.list (get group ID, and check if group is disabled)
	# https://api.slack.com/methods/usergroups.enable (if disabled)
	# https://api.slack.com/methods/usergroups.users.update
end


# TODO
# TODO: also, do this on a cron
def monkey_clear
	slack_secret_message "TODO: Empty out the monkey group"
	# https://api.slack.com/methods/usergroups.list (get group ID, and check if group is disabled)
	# https://api.slack.com/methods/usergroups.disable
end
