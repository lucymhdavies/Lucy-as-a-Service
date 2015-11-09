
Dir.glob('lib/tasks/*.rake').each { |r| load r}

begin
	require 'rspec/core/rake_task'

	RSpec::Core::RakeTask.new :specs do |task|
		task.pattern = Dir['spec/**/*_spec.rb']
	end

	task :default => ['specs']
rescue LoadError
	# no rspec available (i.e. Production)
end
