
def teaflick
	if rand < 0.1
		coin_side = "It fell on the floor!"
	else
		coin_side = ["Heads!", "Tails!"].sample
	end

	at_user = ""
	unless params['user_name'].nil?
		at_user = "<@#{params['user_id']}|#{params['user_name']}>: "
	end

	at_user + coin_side
end
