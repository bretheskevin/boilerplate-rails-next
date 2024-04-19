ENV["RAILS_ENV"] ||= "example"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"

RSpec.configure do |config|
  config.before(:each, type: :request) do

  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include Devise::Test::IntegrationHelpers, type: :request
end
