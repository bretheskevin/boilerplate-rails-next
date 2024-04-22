module Devise
  module Api
    module Responses
      module TokenResponseDecorator
        def default_body
          user_json = UserSerializer.new(resource_owner).as_json

          {
            token: token.access_token,
            refresh_token: Devise.api.config.refresh_token.enabled ? token.refresh_token : nil,
            expires_in: token.expires_in,
            token_type: ::Devise.api.config.authorization.scheme,
            resource_owner: user_json
          }.compact
        end
      end
    end
  end
end
