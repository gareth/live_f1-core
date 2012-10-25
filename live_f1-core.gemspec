# -*- encoding: utf-8 -*-
require File.expand_path('../lib/live_f1/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Gareth Adams"]
  gem.email         = ["g@rethada.ms"]
  gem.description   = %q{Parses raw events from the Formula1.com live timing stream}
  gem.summary       = %q{LiveF1 provides an API to receive data from the official live timing servers. It uses the same data that's streamed to the live timing applet at www.formula1.com/live_timing - and needs you to have a corresponding account to decrypt the stream - but enables you to have a more fine-grained access to the numbers}
  gem.homepage      = "https://github.com/gareth/live_f1-core"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "live_f1-core"
  gem.require_paths = ["lib"]
  gem.version       = LiveF1::VERSION

  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_development_dependency 'cucumber', '~> 1.0'

  gem.add_development_dependency 'rake', '>= 0.9'
  gem.add_development_dependency 'fakeweb', '~> 1.2', '>= 1.2.4'
end
