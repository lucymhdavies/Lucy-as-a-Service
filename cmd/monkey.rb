
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
	when "monkey", "monkey who", "monkeys", "monkeys who", "monkey list", "monkeys list"
		monkey_list
	when "monkey me"
		monkey_me
	when "monkey set", "monkeys set"
		monkey_set
	when "monkey clear", "monkeys clear"
		monkey_clear
	when "monkey help", "monkeys help"
		monkey_help
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
		logger.debug "Usergroups:"
		logger.debug res['usergroups'].inspect
	
		# Filter returned usergroups by name
		$monkey_group = res['usergroups'].select do |usergroup|
			usergroup['handle'] == ENV["SLACK_MONKEY_GROUP"]
		end
		$monkey_group = $monkey_group[0]

		logger.debug "Monkey Group:"
		logger.debug $monkey_group

		# If we have a monkey group (enabled or disabled)
		if $monkey_group
			# Get all enabled groups
			res2 = Slack.usergroups_list( {:include_disabled => 0} )
			logger.debug "Enabled Usergroups:"
			logger.debug res2['usergroups']

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
		logger.debug "Monkey group enabled"
		true
	else
		logger.debug "Monkey group disabled"
		false
	end
end


# TODO: allow quiet listing
# Will not summon users in list
def monkey_list
	if monkey_group_enabled?
		logger.debug "Listing monkeys"

		monkey_group_id = $monkey_group['id']

		message = "Users in <!subteam^#{monkey_group_id}|#{ENV['SLACK_MONKEY_GROUP']}>:\n\n"

		logger.debug "Monkey Group:"
		logger.debug $monkey_group.inspect

		logger.debug "Iterating through monkey group users"
		$monkey_group['users'].each do |uid|
			logger.debug uid.inspect

			user = Slack.users_info( :user => uid )
			p = user['user']
			logger.debug "p = " + p.inspect

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

def monkey_set
	slack_secret_message "TODO: set monkey(s) to specified user(s)"

	# TODO: if no user specified, monkey_clear, monkey_me

	# TODO: if user specified another user group, get all users from that group
end


# TODO
# TODO: also, do this on a cron
def monkey_clear
	slack_secret_message "TODO: Empty out the monkey group"
	# https://api.slack.com/methods/usergroups.list (get group ID, and check if group is disabled)
	# https://api.slack.com/methods/usergroups.disable
end



def monkey_help
	message =  "Manages the Monkey user group.\n\n"

	message += "Available Monkey(s) Subcommands:\n"

	message += "`/laas monkey`, `/laas monkey who`, `/laas monkey list` - Displays current monkey(s)\n"
	# TODO: Mention quiet summoning, once it's available

	message += "`/laas monkey me` - Add yourself to today's monkey(s)\n"

	message += "`/laas monkey set <user> <user> <user>` - Set today's monkeys (will remove anybody not in the specified list)\n"

	message += "`/laas monkey clear` - Empties the monkey group\n"

	message += "`/laas monkey help` - You're seeing it :slightly_smiling_face:"

	slack_secret_message message
end
