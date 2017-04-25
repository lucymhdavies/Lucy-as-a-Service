require 'aws-sdk'

desc "Export DB to file"
task :db_backup do
	db = {}

	$redis.scan_each(match: 'laas:*') do |key|
		ttl = $redis.ttl(key)
		# Skip any temporary keys
		next unless ttl == -1

		# Skip any test keys
		next if key.start_with? "laas:test:"

		#STDERR.puts
		#STDERR.puts "================================================================================"
		STDERR.puts key
		#STDERR.puts "================================================================================"

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

		#STDERR.puts val.inspect

		db[key] = {
			:type  => type,
			:value => val
		}
	end

	#STDERR.puts
	#STDERR.puts "================================================================================"

	db = db.sort

	#puts JSON.generate(db)

	STDERR.puts
	STDERR.puts "================================================================================"
	STDERR.puts "Storing in S3"
	STDERR.puts "================================================================================"

	Aws.config[:credentials] = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])

	s3 = Aws::S3::Resource.new(region:'eu-west-1')
	obj = s3.bucket('db-backups.laas.lmhd.me').object('laas_redis_backup.json')

	# string data
	begin
		obj.put(body: JSON.generate(db))
	rescue Exception => e
		puts "ERROR LaaS Unable to access S3 bucket:"
		puts e.message
	end


end

