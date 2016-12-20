
desc "Log time in DB"
task :db_time do
	puts "Logging time to DB.."
	now = Time.new
	$redis.set( "laas:test:db_time:#{now.to_i}", "#{now.to_s}" )
	puts "Done"
end
