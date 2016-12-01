
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

	# Special summons
	case summon_item.strip
	when "ghosts"
		summon_item = "blinky pinky inky clyde"
	when "mexican wave"
		summon_item = "parrotwave1 parrotwave2 parrotwave3 parrotwave4 parrotwave5 parrotwave6 parrotwave7 parrotwave8 parrotwave9"
	when "spam"
		summon_item = ":party-spam::party-spam::party-spam::party-spam::party-spam::blank::blank::party-spam::party-spam::party-spam::party-spam::party-spam::blank::blank::party-spam::party-spam::party-spam::party-spam::party-spam::blank::blank::party-spam::party-spam::party-spam::party-spam::party-spam:
:party-spam::blank::blank::blank::blank::blank::blank::party-spam::blank::blank::blank::party-spam::blank::blank::party-spam::blank::blank::blank::party-spam::blank::blank::party-spam::blank::party-spam::blank::party-spam:
:party-spam::party-spam::party-spam::party-spam::party-spam::blank::blank::party-spam::party-spam::party-spam::party-spam::party-spam::blank::blank::party-spam::party-spam::party-spam::party-spam::party-spam::blank::blank::party-spam::blank::blank::blank::party-spam:
:blank::blank::blank::blank::party-spam::blank::blank::party-spam::blank::blank::blank::blank::blank::blank::party-spam::blank::blank::blank::party-spam::blank::blank::party-spam::blank::blank::blank::party-spam:
:party-spam::party-spam::party-spam::party-spam::party-spam::blank::blank::party-spam::blank::blank::blank::blank::blank::blank::party-spam::blank::blank::blank::party-spam::blank::blank::party-spam::blank::blank::blank::party-spam:"
		return summon_item
	end

	# TODO: Use slack emoji API to see if such an emoji exists
	if summon_item != ""
		summon_item.split.map{ |i| ":#{i}:" }.join( " " )
	end
end

# TODO: Store these in a DB, along with how often they have been quoted
# Slightly favour quotes which are newer
# Favour quotes which have higher scores (add some sort of liking mechanism later?)
def quote
	quotes = [
		"pscli is love. pscli is life. pscli is all. pscli.",
		"I remembered [the postcode] because it has 'BJ' in it. And I'm 13 years old and amused by such things.",
		"Big warehouse type supermarket. Like if Tesco had sex with America",
		"So exciting! It's like a reverse unboxing video. So... a boxing video. Except I'm not punching anybody.",
		"I'm so low level, I might as well be building this server out of sticks.",
		"Java is a language created by people to show off how clever they are",
		"You have written code which can elevate itself to root privilleges? Sudo code?",
		"You can never be too careful when it comes to eels.",
		"One day, my son, all this will be in Jenkins",
		"The ultimate in automation - keep trying until it works"
	]

	quotes.sample
end

def red_dwarf_quote
	quotes = [
		"The way the light catches all the angles in your head, it's enchanting.",
		"Now kindly cluck off before I extract your giblets and shove a large, seasoned onion between the lips you never kiss with.",
		"Hermann Göring would've been more of a laugh than Rimmer! I mean, OK, he was a drug-crazed transvestite, but at least we could've gone dancing.",
		"I don't want you to think of me as someone who's dead. More of someone who's no longer a threat to your marriages.",
		"Smeg!",
		"He helped me break my programming, sir. Over the years I have managed to develop some serious character faults of which I'm extremely proud! I'm even able to lie to a modest standard, for example: 'you have a very fine hair cut!'",
		"You're probably thinking is this gonna affect my life? And I've been thinking about this and the answer is... Yes it is.",
		"Davey, come oooon. You ve got a virus, it's fatal, it happens. It doesn't mean we can't be friends!",
		"What the hell's happened to my teeth?! I can open beer bottles with my overbite!",
		"I tell you one thing: I've been to a parallel universe, I've seen time running backwards, I've played pool with planets, and I've given birth to twins, but I never thought in my entire life I'd taste an edible Pot Noodle."
	]

	quotes.sample
end


def big_text
	emoji = params['text'].split[1].to_s
	word  = params['text'].split[2].to_s

	unless word && emoji
		slack_secret_message "Insufficient parameters. Call with /laas big_text <emoji> <word>"
	end
font = {
'A' =>
"XXXXX
X   X
XXXXX
X   X
X   X",
'B' =>
"XXXX 
X   X
XXXX 
X   X
XXXX ",
'C' =>
"XXXXX
X    
X    
X    
XXXXX",
'D' =>
"XXXX 
X   X
X   X
X   X
XXXX ",
'E' =>
"XXXXX
X
XXXXX
X
XXXXX",
'F' =>
"",
'G' =>
"",
'H' =>
"",
'I' =>
"",
'J' =>
"",
'K' =>
"",
'L' =>
"",
'M' =>
"XXXXX
X X X
X X X
X   X
X   X",
'N' =>
"X   X
XX  X
X X X
X  XX
X   X",
'O' =>
"XXXXX
X   X
X   X
X   X
XXXXX",
'P' =>
"",
'Q' =>
"",
'R' =>
"",
'S' =>
"",
'T' =>
"",
'U' =>
"",
'V' =>
"",
'W' =>
"",
'X' =>
"",
'Y' =>
"",
'Z' =>
""
}

	rows = ["","","","",""]
	message = ""

	word.scan(/\w/).each do |letter|
		row = font[letter.upcase].split("\n")
		(0..4).each do |i|
			rows[i] += " " + row[i]
		end
	end

	rows.each do |row|
		row = row[1..-1]
		if emoji != nil
			row.gsub! "X", ":#{emoji}:"
			row.gsub! " ", ":blank:"
		end
		message += row + "\n"
	end

	slack_message message
end
