# dummies controller and model class are used for writing specs

class DummiesController < ApplicationController
  def object_class
    base_class
  end

  def not_found_error
  end
end
