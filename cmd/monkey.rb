
# TODO

def monkey
	unless can_use_monkey?
		return slack_secret_message "Unable to use Monkey commands in this Slack team. Wait for OAuth"
	end

	case params['text'].chomp
	when "monkey", "monkey who", "monkeys", "monkeys who"
		slack_secret_message "TODO: List current monkeys. Exclude ps-user"
		# https://api.slack.com/methods/usergroups.list (get group ID, and check if group is disabled)
		# https://api.slack.com/methods/usergroups.users.list
	when "monkey me"
		slack_secret_message "TODO: Add me to today's monkey group, then list monkeys"
		# https://api.slack.com/methods/usergroups.list (get group ID, and check if group is disabled)
		# https://api.slack.com/methods/usergroups.enable (if disabled)
		# https://api.slack.com/methods/usergroups.users.update
	when "monkey clear"
		slack_secret_message "TODO: Empty out the monkey group"
		# https://api.slack.com/methods/usergroups.list (get group ID, and check if group is disabled)
		# https://api.slack.com/methods/usergroups.disable
	else
		slack_secret_message "I don't know what to do with: #{params['text'].chomp}"
	end
end

def can_use_monkey?
	false
end
