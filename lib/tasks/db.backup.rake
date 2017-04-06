
desc "Export DB to file"
task :db_backup do
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
		when "set"
			val = $redis.smembers( key )
			val = val.sort
		else
	 		STDERR.puts $redis.dump( key ).inspect
			raise "Unsupported type: #{type}"
		end

		STDERR.puts val.inspect

		db[key] = {
			:type  => type,
			:value => val
		}
	end

	STDERR.puts
	STDERR.puts "================================================================================"

	db = db.sort

	puts JSON.generate(db)
end

