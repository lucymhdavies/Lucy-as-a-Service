
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
