source :gemcutter

gemspec

# Guard dependencies are here rather than in the gemspec, as gemspec doesn't
# offer a way to conditionally require gems per platform, like below
#
# They aren't development-critical enough to worry about, anyway
gem 'guard-rspec'
gem 'guard-cucumber'

# `:require => ...` will evaluate to either `false` or the correct library string depending on the platform
gem 'growl', :require => RUBY_PLATFORM.include?('darwin') && 'growl'
gem 'rb-fsevent', :require => RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
gem 'rb-inotify', :require => RUBY_PLATFORM.include?('linux') && 'rb-inotify'