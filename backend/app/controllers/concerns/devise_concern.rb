module DeviseConcern
  extend ActiveSupport::Concern

  included do
    skip_before_action :verify_authenticity_token, raise: false
  end

  protected

  # used by devise
  def resource_class
    User
  end
end
