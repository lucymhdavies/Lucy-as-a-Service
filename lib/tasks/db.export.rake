
desc "Export DB to file"
task :db_export do
	db = {}

	$redis.scan_each(match: 'laas:*') do |key|
		ttl = $redis.ttl(key)
		# Skip any temporary keys
		next unless ttl == -1

		# Skip any test keys
		next if key.start_with? "laas:test:"

		STDERR.puts
		STDERR.puts "================================================================================"
		STDERR.puts key
		STDERR.puts "================================================================================"

		type = $redis.type( key )


		case type
		when "string"
			val = $redis.get( key )
			if key.start_with? "laas:config:T"
				val = "PLACEHOLDER VALUE"
			end
		when "set"
			val = $redis.smembers( key )
			if key.start_with? "laas:config:T"
				val = ["PLACEHOLDER SET MEMBER"]
			end
		else
	 		STDERR.puts $redis.dump( key ).inspect
			raise "Unsupported type: #{type}"
		end

		STDERR.puts val.inspect

		# Placeholders for team-specific stuff
		if key.start_with? "laas:config:T"
			key.sub!(/laas:config:T.*:/,"laas:config:team_specific:")
			key.sub!(/laas:config:T.*/,"laas:config:team_specific")
		end

		db[key] = {
			:type  => type,
			:value => val
		}
	end

	STDERR.puts
	STDERR.puts "================================================================================"

	puts JSON.generate(db)
end

