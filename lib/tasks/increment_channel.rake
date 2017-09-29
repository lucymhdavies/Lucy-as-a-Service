
desc "Increment a counter in the channel topic"
task :incr_channel do
	# TODO: get slack instance + channel ID as arguments

	puts "Getting current topic"
	# TODO
	# e.g.
	# curl "https://slack.com/api/channels.info?token=SLACK_TOKEN&channel=C04FFMA2R&pretty=1" 2>/dev/null | jq .channel.topic.value
	# "Days since last topic update: 0"

	# TODO: if topic ends in number...
	# TODO: increment
	puts "New topic: "

	# TODO: Update Slack
	# e.g.
	# https://slack.com/api/channels.setTopic?token=SLACK_TOKEN&channel=C04FFMA2R&topic=Days%20since%20last%20topic%20update%3A%201&pretty=1
end

