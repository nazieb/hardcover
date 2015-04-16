require 'webmock/rspec'
WebMock.disable_net_connect! allow: %w{hardcover.xing.hh}

if ENV['RAILS_ENV'] == 'test'
  require 'coveralls'
  Coveralls.wear! 'rails'

  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    add_filter 'gems'
  end
end

def json_response(name)
  {
    body: File.new("spec/fixtures/#{name}.json"),
    headers: { content_type: 'application/json; charset=utf-8' }
  }
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
