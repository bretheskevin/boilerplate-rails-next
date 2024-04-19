class ApplicationController < ActionController::API
  include CrudConcern
  include DeviseConcern
end
