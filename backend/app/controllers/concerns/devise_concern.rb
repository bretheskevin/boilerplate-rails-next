module DeviseConcern
  extend ActiveSupport::Concern

  protected

  # used by devise
  def resource_class
    User
  end
end
