module DeviseConcern
  extend ActiveSupport::Concern

  included do
  end

  protected

  # used by devise
  def resource_class
    User
  end
end
