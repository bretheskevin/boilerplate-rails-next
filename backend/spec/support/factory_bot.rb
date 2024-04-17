module ApiHelpers
  def json
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include ApiHelpers, type: :request
end
