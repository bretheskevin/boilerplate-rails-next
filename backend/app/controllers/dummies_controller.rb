class DummiesController < ApplicationController
  def base_class
    ::Dummy
  end

  def object_class
    base_class
  end
end
