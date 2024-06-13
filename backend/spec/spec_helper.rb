require "simplecov"
SimpleCov.start do
  add_filter "spec/rails_helper.rb"
  add_filter "spec/spec_helper.rb"
end

ENV["RAILS_ENV"] ||= "example"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"

RSpec.configure do |config|
  config.before(:each, type: :request) do
    @user = create(:user)
    @admin = create(:admin)

    post "/users/tokens/sign_in", params: { email: @user.email, password: @user.password }
    user_token = json["token"]

    post "/users/tokens/sign_in", params: { email: @admin.email, password: @admin.password }
    admin_token = json["token"]

    @user_header = { Authorization: "Bearer #{user_token}" }
    @admin_header = { Authorization: "Bearer #{admin_token}" }
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
