
def xkcd221
	4 # chosen by fair dice roll.
	  # guaranteed to be random
end

# TODO: command to store message, command to playback message

def iou
	"Not implemented"

	# TODO
	# Store a hash of Lucy's usernames on each Slack instance
	# If user is Lucy, then she can say, e.g.:
	# /laas iou @dave 3.00 GBP <reason>
	#
	# No special command to clear an IOU, just:
	# /lass iou @dave 0.00 GBP
	#
	# Then if @dave runs the command
	# /laas iou
	#
	# then it should secret_message:
	# @lucy owes you 3.00 GBP for <reason>
	#
	# Depends on DB
end

def summon
	summon_item = params['text'].sub(/summon */, "")

	# TODO: Use slack emoji API to see if such an emoji exists
	if summon_item != ""
		summon_item.split.map{ |i| ":#{i}:" }.join( " " )
	end
end

def quote
	quotes = [
		"Lucy. But as a service",
		"pscli is love. pscli is life. pscli is all. pscli.",
		"Morry found Ug Hill",
		"I remembered [the postcode] because it has 'BJ' in it. And I'm 13 years old and amused by such things.",
		"Big warehouse type supermarket. Like if Tesco had sex with America",
		"So exciting! It's like a reverse unboxing video. So... a boxing video. Except I'm not punching anybody.",
		"Like!\nSubscribe!\nFollow on Twitter!\nAll that good stuff."
	]

	quotes.sample
end
