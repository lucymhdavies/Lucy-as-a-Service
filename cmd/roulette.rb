
def coffee_roulette
	coffee_pods = $redis.smembers( "laas:roulette:coffee:pods" )
	if coffee_pods.nil? || coffee_pods == ""
		return slack_secret_message "No coffee_pods in DB (yet)"
	end

	coffee_styles = $redis.smembers( "laas:roulette:coffee:styles" )
	if coffee_styles.nil? || coffee_styles == ""
		return slack_secret_message "No coffee_styles in DB (yet)"
	end

	slack_message "'#{coffee_pods.sample}' Pod, #{coffee_styles.sample}"
end

def lunch_roulette
	choices = $redis.smembers( "laas:roulette:lunch" )
	if choices.nil? || choices == ""
		return slack_secret_message "No choices in DB (yet)"
	end

	choices.sample
end

def noodle_roulette
	choices = $redis.smembers( "laas:roulette:noodle:choices" )
	if choices.nil? || choices == ""
		return slack_secret_message "No choices in DB (yet)"
	end

	n = choices.sample

	snark = $redis.smembers( "laas:roulette:noodle:snark" )
	if snark.nil? || snark == ""
		return slack_secret_message "No snark in DB (yet)"
	end

	snark.sample.sub(/CHOICE/, n)
end
