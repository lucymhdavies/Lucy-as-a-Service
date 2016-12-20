
desc "Log time in DB"
task :db_time do
	now = Time.new
	puts "Logging time to DB as laas:test:db_time:#{now.to_i}"
	$redis.set( "laas:test:db_time:#{now.to_i}", "#{now.to_s}" )
	puts "Done"
end
