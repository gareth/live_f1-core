require 'cucumber/rake/task'
require 'rspec/core/rake_task'

Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "--format progress"
end

RSpec::Core::RakeTask.new(:spec)

desc "Run the entire test suite"
task :default => [:spec, :features]
