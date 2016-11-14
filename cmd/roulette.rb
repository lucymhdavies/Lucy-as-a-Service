
# TODO: Pick these from a DB
def coffee_roulette
	coffee_pods = [
		["Lungo Origin Guatamala", "Lungo Forte"],
		["Espresso Forte", "Espresso Leggero", "Espresso Origin Brazil"],
		["Ristretto", "Ristretto Origin India", "Ristretto Intenso"]
	]
	coffee_styles = [
		["Espresso", "Espresso, with Milk", "Espresso Mocha"],
		["Americano", "Americano, with Milk"],
		["Latte"],
		["Mocha"]
	]

	["'" + coffee_pods.sample.sample + "'", "Pod,", coffee_styles.sample.sample].join(" ")
end

# TODO: Pick these from a DB
def lunch_roulette
	choices = [
		"M&S",
		"Oisoi",
		"Smokes!",
		"Sainsburys", "Tesco",
		"Edo Sushi",
		"Burger King", "KFC", "Subway"
	]

	choices.sample
end

def noodle_roulette
	choices = [
		"Beef & Tomato",
		"Original Curry"
	]

	n = choices.sample

	snark = [
		"Wow. Well, if you really want to subject yourself to that, go with #{n}",
		"The least bad option seems to be #{n}",
		"Don't make me make a bad choice for you!",
		"Fine. If you insist. Have #{n}",
		"No.",
		"I'd sooner pull out all my diodes than recommend one of those for you. But if you demand it of me, then... #{n}"
	]

	snark.sample
end
