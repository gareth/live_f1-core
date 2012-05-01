require 'fakeweb'

RSpec::Matchers.define :include_a do |klass|
  match do |actual|
    actual.any? { |item| klass === item }
  end
end

FakeWeb.allow_net_connect = false
