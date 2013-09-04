require 'rspec'
require 'rspec/autorun'
require 'rack/test'
require 'fake_sensu'
require 'fake_sensu/api'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.order = "random"
  config.include Rack::Test::Methods
end
