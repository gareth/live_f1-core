# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "features --format pretty"
end

desc "Run the entire test suite"
task :default => [:spec, :features]

Hoe.plugin :flay

# Hoe.plugin :compiler
# Hoe.plugin :gem_prelude_sucks
# Hoe.plugin :inline
# Hoe.plugin :racc
# Hoe.plugin :rcov
# Hoe.plugin :rubyforge
Hoe.plugin :bundler
Hoe.plugin :git
Hoe.plugin :yard
Hoe.plugin :gemspec

Hoe.spec 'live_f1' do |s|
  
  with_config do |config, _|
    config["exclude"] = Regexp.union(config["exclude"], "features")
  end
  
  developer('Gareth Adams', 'gareth.adams@gmail.com')

  dependency "hpricot", nil, :dev
  dependency "rspec", nil, :dev
  dependency "cucumber", nil, :dev
  
  dependency "guard-rspec", nil, :dev
  dependency "guard-cucumber", nil, :dev
  dependency "growl", nil, :dev

  dependency "fakeweb", nil, :dev
  # dependency "hoe-yard", nil, :dev
  dependency "hoe-gemspec", nil, :dev
end

# vim: syntax=ruby
